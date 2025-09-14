"""
validate_data.py
Runs validation checks on the synthetic workspace_usage dataset.
Saves plots into docs/plots/ and prints summary tables.
"""

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os

# Paths
DATA_PATH = "../data/workspace_usage_simulated.csv"
PLOTS_PATH = "../docs/plots/"

# Ensure plots folder exists
os.makedirs(PLOTS_PATH, exist_ok=True)

# Load dataset
df = pd.read_csv(DATA_PATH)

print("Data loaded successfully!")
print(f"Rows: {df.shape[0]}, Columns: {df.shape[1]}")
print("\n--- Columns ---")
print(df.dtypes)

# 1. Summary statistics
summary = df.describe().T
print("\n--- Summary Statistics ---")
print(summary)
summary.to_csv("../docs/summary_statistics.csv")

# 2. Missing values check
missing = df.isnull().sum()
print("\n--- Missing Values ---")
print(missing)

# 3. Distribution plots for key metrics
for col in ["emails_sent", "meetings_hours", "collaboration_load", "tasks_completed", "productivity_score"]:
    plt.figure(figsize=(6,4))
    sns.histplot(df[col], kde=True, bins=30, color="skyblue")
    plt.title(f"Distribution of {col}")
    plt.savefig(f"{PLOTS_PATH}{col}_distribution.png")
    plt.close()

print("Distribution plots saved!")

# 4. Correlation heatmap
plt.figure(figsize=(8,6))
sns.heatmap(df.corr(numeric_only=True), annot=True, cmap="coolwarm", fmt=".2f")
plt.title("Correlation Heatmap")
plt.savefig(f"{PLOTS_PATH}correlation_heatmap.png")
plt.close()

print("Correlation heatmap saved!")

# 5. Department-level averages
dept_summary = df.groupby("department")[["emails_sent","meetings_hours","collaboration_load","tasks_completed","productivity_score"]].mean()
print("\n--- Department-Level Averages ---")
print(dept_summary.round(2))
dept_summary.to_csv("../docs/department_summary.csv")

plt.figure(figsize=(8,5))
sns.barplot(x=dept_summary.index, y="productivity_score", data=dept_summary.reset_index(), palette="viridis")
plt.title("Average Productivity Score by Department")
plt.xticks(rotation=30)
plt.savefig(f"{PLOTS_PATH}dept_productivity.png")
plt.close()

print("  Department-level plot saved!")

print("\n Validation checks complete. Results saved in /docs/")
                 