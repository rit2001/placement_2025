# File: 1_credit_risk_pipeline.py
# Language: Python
# Purpose: Preprocess credit dataset, build ML model for risk classification, and save outputs for Tableau.

"""
Dependencies:
  pip install pandas numpy scikit-learn joblib
"""

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import classification_report, roc_auc_score
import joblib

# ------------------------- Config -------------------------
DATA_PATH = "data/credit_data.csv"
MODEL_PATH = "outputs/credit_risk_model.pkl"

# ------------------------- Pipeline -------------------------

def load_data(path: str) -> pd.DataFrame:
    return pd.read_csv(path)

def preprocess(df: pd.DataFrame):
    # Example: encode categorical vars, scale numeric vars
    df = df.dropna()
    X = df.drop("default", axis=1)
    y = df["default"]

    # one-hot encoding for categoricals
    X = pd.get_dummies(X, drop_first=True)

    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    return X_scaled, y, scaler, X.columns

def train_model(X, y):
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    model = LogisticRegression(max_iter=1000)
    model.fit(X_train, y_train)

    preds = model.predict(X_test)
    probs = model.predict_proba(X_test)[:,1]

    print(classification_report(y_test, preds))
    print("ROC-AUC:", roc_auc_score(y_test, probs))
    return model


def main():
    df = load_data(DATA_PATH)
    X, y, scaler, feature_names = preprocess(df)
    model = train_model(X, y)

    # save model and metadata
    joblib.dump({"model": model, "scaler": scaler, "features": feature_names.tolist()}, MODEL_PATH)
    print("Model saved at", MODEL_PATH)

if __name__ == "__main__":
    main()


# -----------------------------------------------------------------
# File: 2_chatbot_hr_sentiment.py
# Language: Python
# Purpose: GPT-4-driven chatbot for HR conversations with sentiment detection (DistilBERT).

"""
Dependencies:
  pip install openai transformers torch
  # set OPENAI_API_KEY in environment
"""

import os
import openai
from transformers import pipeline

openai.api_key = os.getenv("OPENAI_API_KEY")

# sentiment model
sentiment_analyzer = pipeline("sentiment-analysis", model="distilbert-base-uncased-finetuned-sst-2-english")

def ask_gpt4(prompt: str) -> str:
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[{"role": "system", "content": "You are an HR assistant."},
                  {"role": "user", "content": prompt}]
    )
    return response.choices[0].message["content"]

def analyze_conversation(user_input: str):
    sentiment = sentiment_analyzer(user_input)[0]
    reply = ask_gpt4(user_input)
    return {"user": user_input, "sentiment": sentiment, "bot_reply": reply}

if __name__ == "__main__":
    while True:
        text = input("You: ")
        if text.lower() in ["exit","quit"]:
            break
        out = analyze_conversation(text)
        print("Bot:", out["bot_reply"])
        print("(Sentiment:", out["sentiment"], ")")


# -----------------------------------------------------------------
# File: 3_tableau_queries.sql
-- Purpose: SQL queries to prepare tables for Tableau dashboards.

-- Create cleaned loan applications table
CREATE TABLE IF NOT EXISTS clean_loans AS
SELECT
    app_id,
    customer_id,
    loan_amount,
    income,
    employment_length,
    age,
    default
FROM raw_loans
WHERE loan_amount > 0 AND income > 0;

-- Aggregate defaults by month
CREATE VIEW IF NOT EXISTS v_monthly_defaults AS
SELECT
    strftime('%Y-%m', application_date) AS month,
    COUNT(*) AS total_apps,
    SUM(default) AS defaults,
    ROUND(1.0*SUM(default)/COUNT(*), 3) AS default_rate
FROM clean_loans
GROUP BY month
ORDER BY month;

-- Risk segmentation by income brackets
CREATE VIEW IF NOT EXISTS v_risk_by_income AS
SELECT
    CASE 
        WHEN income < 20000 THEN 'Low Income'
        WHEN income BETWEEN 20000 AND 50000 THEN 'Mid Income'
        ELSE 'High Income' END AS income_group,
    COUNT(*) AS total_customers,
    SUM(default) AS defaults,
    ROUND(1.0*SUM(default)/COUNT(*),3) AS default_rate
FROM clean_loans
GROUP BY income_group;
