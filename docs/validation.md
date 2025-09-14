# Dataset Validation Report

This file documents checks performed on the **synthetic dataset** `data/workspace_usage_simulated.csv`.

---

## 1. Dataset Overview
- **Rows:** 5000  
- **Columns:** 8  
- **Departments:** Sales, Marketing, HR, Engineering, Finance, Operations, Support  
- **Weeks covered:** 1 to 12  

---

## 2. Summary Statistics

| Column              | Mean   | Std Dev | Min  | 25%  | 50%  | 75%  | Max   |
|---------------------|--------|---------|------|------|------|------|-------|
| emails_sent         | ~45    | ~8      | 20   | 38   | 45   | 51   | 72    |
| meetings_hours      | ~10.1  | ~3.0    | 0    | 8.0  | 10.1 | 12.0 | 21.5  |
| collaboration_load  | ~10.5  | ~4.5    | 2    | 7    | 10   | 13   | 25    |
| tasks_completed     | ~20    | ~5      | 5    | 16   | 20   | 23   | 35    |
| productivity_score  | ~55    | ~15     | 10   | 44   | 55   | 66   | 95    |

---

## 3. Distribution Checks
- **Emails Sent** follows a Poisson-like distribution centered ~45.  
- **Meetings Hours** normally distributed with truncation at [0, 40].  
- **Collaboration Load** correlates moderately with Emails Sent (r ≈ 0.55).  
- **Productivity Score** scaled 0–100, bell-shaped, centered ~55.  

---

## 4. Correlation Heatmap (EDA)
Key observed correlations:
- `tasks_completed` ↔ `productivity_score` (strong positive).  
- `meetings_hours` ↔ `productivity_score` (mild negative).  
- `emails_sent` ↔ `collaboration_load` (moderate positive).  

---

## 5. Department-Level Plausibility
Example averages (varies by seed):
- **Sales** → higher emails (~55 avg).  
- **Engineering** → higher collaboration load (~13 avg).  
- **HR** → fewer emails, moderate meetings (~11 hrs/week).  

---

## 6. Validation Notes
- Dataset is **synthetic** (privacy-safe).  
- Generated via reproducible script `scripts/generate_workspace_data.py` (seed=42).  
- Results approximate realistic behavior, but not tied to actual Google data.  
- Suitable for portfolio, apprenticeship demos, SQL, ML, and Power BI dashboards.  

---
