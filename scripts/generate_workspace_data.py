# generate_workspace_data.py
import numpy as np
import pandas as pd

SEED = 42
np.random.seed(SEED)

n = 5000
departments = ["Sales","Marketing","HR","Engineering","Finance","Operations","Support"]

# employee ids
employee_ids = [f"E{str(i).zfill(4)}" for i in range(1, n+1)]
dept_choices = np.random.choice(departments, size=n, p=[0.15,0.15,0.1,0.25,0.12,0.13,0.1])

# realistic-ish distributions
emails_sent = np.random.poisson(lam=45, size=n)                      # emails/week
meetings_hours = np.clip(np.random.normal(loc=10, scale=3, size=n), 0, 40)  # hours/week
collab_docs = np.random.poisson(lam=6, size=n)                       # docs/sheets/actions
tasks_completed = np.random.poisson(lam=20, size=n)

# build collaboration_load consistent with components
collaboration_load = collab_docs + (emails_sent // 10)  # example formula

# create a productivity_score (illustrative formula)
# higher tasks, moderate meetings, moderate collaboration -> higher productivity
prod = (
    0.5 * (tasks_completed / (tasks_completed.max())) +
    -0.3 * (meetings_hours / (meetings_hours.max())) +
    0.2 * (collaboration_load / (collaboration_load.max()))
)
# scale to 0..100 and add a bit of noise
productivity_score = (prod - prod.min()) / (prod.max() - prod.min())
productivity_score = (productivity_score * 80) + 10 + np.random.normal(0, 3, size=n)
productivity_score = np.clip(productivity_score, 0, 100)

df = pd.DataFrame({
    "employee_id": employee_ids,
    "department": dept_choices,
    "week": np.random.randint(1,13,size=n),
    "emails_sent": emails_sent,
    "meetings_hours": np.round(meetings_hours,2),
    "collaboration_load": collaboration_load,
    "tasks_completed": tasks_completed,
    "productivity_score": np.round(productivity_score,2),
})

df.to_csv("workspace_usage_simulated.csv", index=False)
print("Saved workspace_usage_simulated.csv (seed=%d)" % SEED)
