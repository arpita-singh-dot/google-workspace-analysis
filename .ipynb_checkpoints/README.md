# 🧾 Optimizing Collaboration: Google Workspace Usage Analysis

_ Analyzed Google Workspace data to uncover usage patterns, measure productivity, and identify opportunities for improved collaboration efficiency ._

---

## 📌 Table of Contents
- <a href="#overview">Overview</a>
- <a href="#business-problem">Business Problem</a>
- <a href="#dataset">Dataset</a>
- <a href="#tools--technologies">Tools & Technologies</a>
- <a href="#project-structure">Project Structure</a>
- <a href="#data-cleaning--preparation">Data Cleaning & Preparation</a>
- <a href="#exploratory-data-analysis-eda">Exploratory Data Analysis (EDA)</a>
- <a href="#research-questions--key-findings">Research Questions & Key Findings</a>
- <a href="#dashboard">Dashboard</a>
- <a href="#how-to-run-this-project">How to Run This Project</a>
- <a href="#final-recommendations">Final Recommendations</a>
- <a href="#author--contact">Author & Contact</a>

---
<h2><a class="anchor" id="overview"></a>Overview</h2>

This project focuses on analyzing Google Workspace data to understand how teams use tools like Gmail, Meet, Calendar, and Drive. By studying usage patterns, we can identify how employees collaborate, where time is spent the most, and whether productivity is improving. The goal is to make smarter decisions about collaboration, reduce inefficiencies, and improve team performance.

---
<h2><a class="anchor" id="business-problem"></a>Business Problem</h2>

Organizations invest heavily in Google Workspace to boost productivity, but often struggle to measure its true impact. Some common questions arise:
 - Are employees using meetings effectively, or are they spending too much time in them?
 - Which tools drive the most collaboration and which remain underutilized?
 - Is there an opportunity to reduce meeting time and increase focus hours?
 - How can we use Workspace data to improve team efficiency and cut unnecessary costs?
 - This project answers these questions by turning raw Google Workspace usage data into clear insights that help business leaders optimize collaboration.

---

<h2><a class="anchor" id="dataset"></a>Dataset Provenance</h2>

This project uses a **synthetic dataset** (`workspace_usage_simulated.csv`) that mimics Google Workspace usage logs.  

### Why synthetic?
- Real Workspace telemetry is private and inaccessible.  
- Synthetic data allows reproducible, privacy-safe demonstrations.  

### Reproducibility
- Generated using `/scripts/generate_workspace_data.py` (Python, seed=42).  
- Validation results documented in `/docs/validation.md`.  

### Columns
- `employee_id` — unique employee code (E0001, E0002…)  
- `department` — Sales, Marketing, HR, etc.  
- `week` — week index (1–12)  
- `emails_sent` — number of emails sent that week  
- `meetings_hours` — hours spent in meetings  
- `collaboration_load` — combined collaboration actions (docs/sheets/etc.)  
- `tasks_completed` — tasks done that week  
- `productivity_score` — scaled score (0–100), derived from above metrics 

---

<h2><a class="anchor" id="tools--technologies"></a>Tools & Technologies</h2>

SQL – to write queries for extracting insights, filtering data, and solving business questions directly from the dataset.

Python (Pandas, Matplotlib, Seaborn) – for deeper analysis, statistical exploration, and creating visualizations.

Data Visualization ( Power BI) – to present findings in an interactive and business-friendly way.

GitHub – to store and manage project files, share code, and maintain documentation (README, scripts, datasets).

---
<h2><a class="anchor" id="project-structure"></a>Project Structure</h2>

```
Google-Workspace-Analysis/
│
├── data/                    
│   └── workspace_usage.csv        # Raw dataset (Google Workspace usage data)
│   └──employee_feature.csv
├── notebooks/              
│   └── Workspace_ML.ipynb             # Performing ML for prediction
│   └── Workspace_Project.ipynb         # Python notebook with data cleaning & EDA
├── sql/                    
│   └── queries.sql                # SQL queries used for business problems
│
├── dashboards/             
│   └── Workspace_employee_productivity.pbix
│
├── README.md               
└── requirements.txt        

```

---
<h2><a class="anchor" id="data-cleaning--preparation"></a>Data Cleaning & Preparation</h2>

- Filling or removing missing values.
- Making dates and numbers consistent (same format/units).
- Removing duplicates and obvious errors.
- Creating useful new columns (like meeting hours per user).
- Filtering out extreme or unrealistic values.

---
<h2><a class="anchor" id="exploratory-data-analysis-eda"></a>Exploratory Data Analysis (EDA)</h2>

**Negative or Zero Values Detected:**
- We explored the cleaned dataset to understand patterns and trends:
- Checked overall usage of Gmail, Meet, Calendar, and Drive.
- Looked at meeting hours, active vs. inactive users, and storage usage.
- Found which tools are most used and where time is spent the most.
- Identified trends like high meeting load vs. focus time.

**Outliers Identified:**
- Users with extremely high meeting counts (for e.g- 1000+ meetings in a week).
- Storage usage values that were far beyond normal limits.
- Very high or very low activity compared to the rest of the users.

**Correlation Analysis:**
- More meeting hours often meant less focus time.
- Higher Drive usage was linked with more collaboration activity.
- Active users in Calendar also tended to be more active in Meet.

---
<h2><a class="anchor" id="research-questions--key-findings"></a>Research Questions & Key Findings</h2>

Research Questions:
  - How much time do employees spend in meetings?
  - Which Google Workspace tools are used the most?
  - Are meetings reducing focus/productive time?
  - Who are the most active vs. inactive users?
  - Can collaboration be improved to save time and cost?

Key Findings:
  - Meetings take a big share of working hours, often reducing focus time.
  - Gmail and Calendar are the most widely used tools, followed by Drive.
  - A small group of users are very active, while many remain underutilizing Workspace.
  - Heavy storage use shows strong collaboration through file sharing.
  - Balancing meetings and focus time can improve productivity
---
<h2><a class="anchor" id="dashboard"></a>Dashboard</h2>

- Power BI Dashboard shows:
- An interactive dashboard was created to visualize key metrics like meeting hours, tool usage, and active users.
- It provides quick insights into collaboration patterns and helps identify areas for productivity improvement.

---
<h2><a class="anchor" id="how-to-run-this-project"></a>How to Run This Project</h2>

1. Clone the repository:
```bash
git clone https://github.com/yourusername/google-workspace-analysis.git

```
-Open and run notebooks:
   - `notebooks/Workspace_Project.ipynb`
   - `notebooks/Workspace_ML.ipynb`

-Open Power BI Dashboard:
   - `dashboard/Workspace_employee_productivity.pbix`

---
<h2><a class="anchor" id="final-recommendations"></a>Final Recommendations</h2>

- Reduce unnecessary meetings to give employees more focus time.
- Promote balanced tool usage so all teams use Gmail, Drive, Calendar, and Meet effectively.
- Monitor storage growth and encourage better file management to save costs.
- Identify inactive users and provide training to boost adoption of Workspace tools.
- Regularly track usage patterns with dashboards to keep improving collaboration efficiency.

---
<h2><a class="anchor" id="author--contact"></a>Author & Contact</h2>

**Arpita Singh**   
📧 Email: arpitasingh15152115@gmail.com  


