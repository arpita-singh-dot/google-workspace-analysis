## 📊 Dataset Provenance

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
