# File: 1_data_pipeline_and_forecasting.py
# Language: Python 3.10+
# Purpose: data cleaning, feature engineering, time-series forecasting (ARIMA & Prophet), RFM-based KMeans customer segmentation,
#          and saving outputs for Power BI dashboard ingestion.
# Notes: replace placeholder paths and credentials; add error-handling and logging as needed for production.

"""
Dependencies (recommended):
  pip install pandas numpy scikit-learn prophet pmdarima sqlalchemy openpyxl
  # If prophet install issues, use: pip install prophet --pre (depending on environment)
"""

import os
from pathlib import Path
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from prophet import Prophet
import pmdarima as pm
from sqlalchemy import create_engine

# ------------------------- Configuration -------------------------
DATA_PATH = "data/transactions.csv"            # input raw transactions (order_id, customer_id, date, qty, price, etc.)
OUTPUT_DIR = Path("outputs")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
DB_CONN_STR = "sqlite:///data/retail.db"      # replace with production DB connection

# ------------------------- Helper functions -------------------------

def load_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, parse_dates=["order_date"])  # ensure order_date column exists
    return df


def preprocess_transactions(df: pd.DataFrame) -> pd.DataFrame:
    # Standard clean: remove duplicates, nulls, ensure numeric types, create sales column
    df = df.drop_duplicates()
    df = df.dropna(subset=["order_id", "customer_id", "order_date", "quantity", "price"]) 
    df["quantity"] = df["quantity"].astype(int)
    df["price"] = df["price"].astype(float)
    df["sales"] = df["quantity"] * df["price"]
    df = df.sort_values("order_date")
    return df


# ------------------------- Time-series forecasting -------------------------

def aggregate_daily_sales(df: pd.DataFrame) -> pd.DataFrame:
    daily = df.groupby(df["order_date"].dt.floor("D")).agg(daily_sales=("sales", "sum"))
    daily = daily.reset_index().rename(columns={"order_date":"ds","daily_sales":"y"})
    return daily


def forecast_with_prophet(daily_df: pd.DataFrame, periods: int = 30) -> pd.DataFrame:
    m = Prophet(daily_seasonality=True, yearly_seasonality=True, weekly_seasonality=True)
    m.fit(daily_df)
    future = m.make_future_dataframe(periods=periods)
    forecast = m.predict(future)
    result = forecast[["ds","yhat","yhat_lower","yhat_upper"]]
    return result


def forecast_with_arima(daily_df: pd.DataFrame, periods: int = 30) -> pd.DataFrame:
    # Use pmdarima.auto_arima to select best model, then forecast
    series = daily_df.set_index("ds")["y"].asfreq("D").fillna(0)
    model = pm.auto_arima(series, seasonal=True, m=7, suppress_warnings=True, stepwise=True)
    preds = model.predict(n_periods=periods)
    future_idx = pd.date_range(series.index[-1] + pd.Timedelta(days=1), periods=periods, freq="D")
    return pd.DataFrame({"ds": future_idx, "yhat_arima": preds})


# ------------------------- RFM & Customer Segmentation -------------------------

def compute_rfm(df: pd.DataFrame, snapshot_date=None) -> pd.DataFrame:
    if snapshot_date is None:
        snapshot_date = df["order_date"].max() + pd.Timedelta(days=1)

    rfm = df.groupby("customer_id").agg(
        Recency=("order_date", lambda x: (snapshot_date - x.max()).days),
        Frequency=("order_id", "nunique"),
        Monetary=("sales", "sum")
    ).reset_index()

    # Replace zeros and negative values if any
    rfm["Monetary"] = rfm["Monetary"].clip(lower=0.01)
    return rfm


def rfm_kmeans(rfm: pd.DataFrame, n_clusters=4) -> pd.DataFrame:
    # Log transform monetary and recency to reduce skew
    features = rfm[["Recency","Frequency","Monetary"]].copy()
    features["Monetary"] = np.log1p(features["Monetary"])
    features["Recency"] = np.log1p(features["Recency"])

    scaler = StandardScaler()
    X = scaler.fit_transform(features)

    kmeans = KMeans(n_clusters=n_clusters, random_state=42)
    rfm["segment"] = kmeans.fit_predict(X)
    # Optionally compute segment centroids or ranking
    return rfm


# ------------------------- Save outputs -------------------------

def save_forecasts(prophet_df: pd.DataFrame, arima_df: pd.DataFrame, outdir: Path):
    prophet_df.to_csv(outdir / "forecast_prophet.csv", index=False)
    arima_df.to_csv(outdir / "forecast_arima.csv", index=False)


def save_rfm(rfm_df: pd.DataFrame, outdir: Path):
    rfm_df.to_csv(outdir / "customer_rfm_segments.csv", index=False)


# ------------------------- Main pipeline -------------------------

def main():
    print("Loading data...")
    df = load_data(DATA_PATH)
    df = preprocess_transactions(df)

    print("Aggregating daily sales and forecasting...")
    daily = aggregate_daily_sales(df)
    prophet_forecast = forecast_with_prophet(daily, periods=90)
    arima_forecast = forecast_with_arima(daily, periods=90)
    save_forecasts(prophet_forecast, arima_forecast, OUTPUT_DIR)

    print("Computing RFM and segments...")
    rfm = compute_rfm(df)
    rfm_segmented = rfm_kmeans(rfm, n_clusters=5)
    save_rfm(rfm_segmented, OUTPUT_DIR)

    # Optionally write to a local DB for Power BI to read
    engine = create_engine(DB_CONN_STR)
    daily.to_sql("daily_sales", engine, if_exists="replace", index=False)
    rfm_segmented.to_sql("customer_rfm", engine, if_exists="replace", index=False)

    print("Pipeline finished. Outputs written to:", OUTPUT_DIR)


if __name__ == "__main__":
    main()


# -----------------------------------------------------------------
# File: 2_etl_and_aggregation_queries.sql
-- Language: SQL (ANSI; tested on SQLite/Postgres with minor tweaks)
-- Purpose: provides sample DDL and queries for aggregations and RFM that Power BI can consume.

-- 1) Create raw_transactions table (example schema)
CREATE TABLE IF NOT EXISTS raw_transactions (
    order_id TEXT,
    customer_id TEXT,
    order_date TIMESTAMP,
    product_id TEXT,
    quantity INTEGER,
    price NUMERIC,
    sales NUMERIC
);

-- 2) Create cleaned_transactions (simple transformation)
CREATE TABLE IF NOT EXISTS cleaned_transactions AS
SELECT
  order_id,
  customer_id,
  DATE(order_date) AS order_date,
  product_id,
  quantity,
  price,
  quantity * price AS sales
FROM raw_transactions
WHERE order_id IS NOT NULL
  AND customer_id IS NOT NULL
  AND quantity > 0;

-- 3) Daily sales aggregation view
CREATE VIEW IF NOT EXISTS v_daily_sales AS
SELECT
  order_date AS ds,
  SUM(sales) AS y
FROM cleaned_transactions
GROUP BY order_date
ORDER BY order_date;

-- 4) RFM calculation
-- snapshot_date should be a fixed date or use current_date in production
WITH last_order AS (
  SELECT customer_id, MAX(order_date) AS last_date FROM cleaned_transactions GROUP BY customer_id
),
freq AS (
  SELECT customer_id, COUNT(DISTINCT order_id) AS frequency FROM cleaned_transactions GROUP BY customer_id
),
monetary AS (
  SELECT customer_id, SUM(sales) AS monetary FROM cleaned_transactions GROUP BY customer_id
)
SELECT
  l.customer_id,
  julianday('now') - julianday(l.last_date) AS recency_days,
  f.frequency,
  m.monetary
FROM last_order l
JOIN freq f ON f.customer_id = l.customer_id
JOIN monetary m ON m.customer_id = l.customer_id;

-- 5) Sample KPI query for Power BI
SELECT
  ds,
  y AS daily_revenue,
  AVG(y) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_7d_avg,
  SUM(y) OVER (ORDER BY ds ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS rolling_30d_sum
FROM v_daily_sales
ORDER BY ds;

-- 6) Save a table of top N customers by revenue
CREATE TABLE IF NOT EXISTS top_customers AS
SELECT customer_id, SUM(sales) AS total_revenue
FROM cleaned_transactions
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 100;

-- Add any indices for performance
CREATE INDEX IF NOT EXISTS idx_cleaned_order_date ON cleaned_transactions(order_date);
CREATE INDEX IF NOT EXISTS idx_cleaned_customer_id ON cleaned_transactions(customer_id);
