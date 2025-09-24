# File: 1_data_integration_pipeline.py
# Language: Python
# Purpose: Integrate multiple HR datasets (attendance, surveys, attrition), clean & prepare unified dataset.

"""
Dependencies:
  pip install pandas numpy sqlalchemy openpyxl
"""

import pandas as pd
from sqlalchemy import create_engine
from pathlib import Path

# Config
DATA_DIR = Path("data")
OUTPUT_DIR = Path("outputs")
OUTPUT_DIR.mkdir(exist_ok=True)
DB_CONN_STR = "sqlite:///data/hr_analytics.db"

# File paths
ATTENDANCE = DATA_DIR / "attendance.csv"
SURVEY = DATA_DIR / "engagement_survey.xlsx"
ATTRITION = DATA_DIR / "attrition.csv"


def load_datasets():
    df_att = pd.read_csv(ATTENDANCE, parse_dates=["date"])
    df_survey = pd.read_excel(SURVEY)
    df_attr = pd.read_csv(ATTRITION)
    return df_att, df_survey, df_attr


def unify_datasets(df_att, df_survey, df_attr):
    # Merge on employee_id
    df = df_att.merge(df_survey, on="employee_id", how="left")
    df = df.merge(df_attr, on="employee_id", how="left")
    return df


def main():
    att, survey, attr = load_datasets()
    unified = unify_datasets(att, survey, attr)
    unified.to_csv(OUTPUT_DIR / "unified_hr_data.csv", index=False)

    engine = create_engine(DB_CONN_STR)
    unified.to_sql("hr_data", engine, if_exists="replace", index=False)
    print("Unified HR dataset stored in outputs/ and database")

if __name__ == "__main__":
    main()


# -----------------------------------------------------------------
# File: 2_anomaly_detection.py
# Language: Python
# Purpose: Apply Isolation Forest to detect anomalies in HR data (attendance anomalies, disengagement, etc.)

"""
Dependencies:
  pip install scikit-learn matplotlib seaborn
"""

import pandas as pd
from sklearn.ensemble import IsolationForest
import matplotlib.pyplot as plt
import seaborn as sns

INPUT_PATH = "outputs/unified_hr_data.csv"
OUTPUT_PATH = "outputs/hr_anomalies.csv"


def detect_anomalies():
    df = pd.read_csv(INPUT_PATH)

    # Example features for anomaly detection
    features = ["attendance_rate", "engagement_score", "overtime_hours"]
    df = df.dropna(subset=features)

    model = IsolationForest(contamination=0.05, random_state=42)
    df["anomaly"] = model.fit_predict(df[features])

    # -1 means anomaly, 1 means normal
    df.to_csv(OUTPUT_PATH, index=False)
    print(f"Anomalies saved to {OUTPUT_PATH}")

    # Quick visualization
    sns.scatterplot(x="attendance_rate", y="engagement_score", hue="anomaly", data=df, palette="coolwarm")
    plt.title("Employee Anomaly Detection")
    plt.savefig("outputs/anomaly_plot.png")
    plt.close()

if __name__ == "__main__":
    detect_anomalies()


# -----------------------------------------------------------------
# File: 3_powerbi_queries.sql
-- Purpose: SQL queries for Power BI to feed HR analytics dashboard

-- 1) Create unified view with anomalies
CREATE VIEW IF NOT EXISTS v_hr_overview AS
SELECT
    employee_id,
    department,
    attendance_rate,
    engagement_score,
    overtime_hours,
    attrition_flag,
    anomaly
FROM hr_data;

-- 2) Department-level productivity summary
CREATE VIEW IF NOT EXISTS v_department_summary AS
SELECT
    department,
    AVG(attendance_rate) AS avg_attendance,
    AVG(engagement_score) AS avg_engagement,
    SUM(attrition_flag) AS total_attrition,
    SUM(CASE WHEN anomaly = -1 THEN 1 ELSE 0 END) AS anomalies_detected
FROM hr_data
GROUP BY department;

-- 3) Attrition trends over time
CREATE VIEW IF NOT EXISTS v_attrition_trends AS
SELECT
    strftime('%Y-%m', date) AS month,
    COUNT(DISTINCT employee_id) AS active_employees,
    SUM(attrition_flag) AS monthly_attrition
FROM hr_data
JOIN attendance ON hr_data.employee_id = attendance.employee_id
GROUP BY month
ORDER BY month;
