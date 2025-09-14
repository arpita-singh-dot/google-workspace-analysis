-----1.Department productivity & meeting hours----
-- Q1: Which departments spend the most time in meetings, on average?
SELECT Department,
       TRUNC(AVG(Meetings_Hours)::NUMERIC, 2) AS avg_meeting_hours,
       TRUNC(AVG(Productivity_Score)::NUMERIC, 2) AS avg_productivity
FROM workspace_usage
GROUP BY Department;
--OR--
--Q1: Which departments spend more time in meetings and how does that affect productivity?
SELECT Department,
       ROUND(AVG(Meetings_Hours)::NUMERIC,2) AS avg_meeting_hours,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_productivity
FROM workspace_usage
GROUP BY Department
ORDER BY avg_meeting_hours DESC;

----2.Top employees by productivity---- 
--Q2: Who are the top 10 most productive employees overall?
SELECT Employee_ID,
       Department,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_productivity
FROM workspace_usage
GROUP BY Employee_ID, Department
ORDER BY avg_productivity DESC
LIMIT 10;

----3.Weekly productivity trend---
--Q3: How does average productivity change week by week across the company?
SELECT Week,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_productivity
FROM workspace_usage
GROUP BY Week
ORDER BY Week;

--4.three-week moving average by department
--Q4: What’s the smoothed trend of productivity for each department?
WITH dept_week AS (
    SELECT Department, Week,
           AVG(Productivity_Score) AS avg_prod
    FROM workspace_usage
    GROUP BY Department, Week
)
SELECT Department, Week,
       ROUND(AVG(avg_prod) OVER (
           PARTITION BY Department
           ORDER BY Week
           ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
       )::NUMERIC,2) AS moving_avg_prod
FROM dept_week
ORDER BY Department, Week;

--5.Week-over-week % change in productivity
--Q5: Which departments show the fastest improvement or decline?
WITH dept_week AS (
    SELECT Department, Week,
           AVG(Productivity_Score) AS avg_prod
    FROM workspace_usage
    GROUP BY Department, Week
)
SELECT Department, Week, 
       ROUND(avg_prod::NUMERIC, 2) AS avg_prod,
       ROUND(
         (100.0 * (avg_prod - LAG(avg_prod) OVER (PARTITION BY Department ORDER BY Week))
         / NULLIF(LAG(avg_prod) OVER (PARTITION BY Department ORDER BY Week),0))::NUMERIC, 2
       ) AS pst_change
FROM dept_week
ORDER BY Department, Week;

--6.Correlation between meetings & productivity
--Q6: Are more meetings associated with higher or lower productivity?
SELECT CORR(Meetings_Hours, Productivity_Score) AS correl_meet_prod
FROM workspace_usage;
--NOTE-Negative correlation = more meetings, less productivity.

--7.Linear regression slope in SQL
--Q7: By how much does productivity change per extra meeting hour?
SELECT REGR_SLOPE(Productivity_Score, Meetings_Hours) AS slope,
       REGR_INTERCEPT(Productivity_Score, Meetings_Hours) AS intercept,
       REGR_R2(Productivity_Score, Meetings_Hours) AS r_squared
FROM workspace_usage;

--8.Outlier detection (meeting overload)
--Q8: Which employees have unusually high meeting hours compared to peers?
WITH stats AS (
  SELECT Department,
         AVG(Meetings_Hours) AS avg_m,
         STDDEV_POP(Meetings_Hours) AS sd_m
  FROM workspace_usage
  GROUP BY Department
)
SELECT w.Employee_ID, w.Department, w.Week, w.Meetings_Hours,
       ROUND(((w.Meetings_Hours - s.avg_m) / NULLIF(s.sd_m,0))::NUMERIC,2) AS z_score
FROM workspace_usage w
JOIN stats s USING (Department)
WHERE (w.Meetings_Hours - s.avg_m) / NULLIF(s.sd_m,0) > 3
ORDER BY z_score DESC;

--9.Productivity percentiles
--Q9: What are the P25, P50 (median), and P75 thresholds of productivity?
SELECT
  percentile_cont(0.25) WITHIN GROUP (ORDER BY Productivity_Score) AS per25,
  percentile_cont(0.5)  WITHIN GROUP (ORDER BY Productivity_Score) AS median,
  percentile_cont(0.75) WITHIN GROUP (ORDER BY Productivity_Score) AS per75
FROM workspace_usage;

---10.Employee cohort analysis
--Q10: Do employees stay consistently productive after their first observed week?
WITH first_week AS (
  SELECT Employee_ID, MIN(Week) AS cohort_week
  FROM workspace_usage
  GROUP BY Employee_ID
),
activity AS (
  SELECT f.cohort_week, w.Week,
         COUNT(DISTINCT w.Employee_ID) AS active_count
  FROM workspace_usage w
  JOIN first_week f ON w.Employee_ID = f.Employee_ID
  GROUP BY f.cohort_week, w.Week
)
SELECT *
FROM activity
ORDER BY cohort_week, Week;

--11.Feature engineering — per-employee summary table
--Q11: What are the key features per employee (for ML or clustering in Python)?
CREATE TABLE employee_features AS
SELECT Employee_ID,
       ANY_VALUE(Department) AS Department,
       COUNT(*) AS weeks_observed,
       ROUND(AVG(Emails_Sent)::NUMERIC,2) AS avg_emails_sent,
       ROUND(AVG(Meetings_Hours)::NUMERIC,2) AS avg_meetings_hours,
       ROUND(AVG(Collaboration_Load)::NUMERIC,2) AS avg_collab_load,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_productivity,
       ROUND(STDDEV_POP(Productivity_Score)::NUMERIC,2) AS sd_productivity
FROM workspace_usage
GROUP BY Employee_ID;
----NOTE-We Export this employee_features table to CSV → analyze in Python (clustering, regression).

--12.Best practices employees
--Q12: Who achieves high productivity with fewer meetings?
WITH emp AS (
  SELECT Employee_ID,
         AVG(Meetings_Hours) AS avg_meet,
         AVG(Productivity_Score) AS avg_prod
  FROM workspace_usage
  GROUP BY Employee_ID
)
SELECT *
FROM emp
WHERE avg_meet < (SELECT AVG(Meetings_Hours) FROM workspace_usage)
  AND avg_prod > (SELECT AVG(Productivity_Score) FROM workspace_usage)
ORDER BY avg_prod DESC;

--13.Dashboard-friendly summarized view
--Q13: Create a view for quick BI dashboarding
CREATE OR REPLACE VIEW vw_dept_week_kpis AS
SELECT Department, Week,
       ROUND(AVG(Meetings_Hours)::NUMERIC,2) AS avg_meetings_hours,
       ROUND(AVG(Communication_Load)::NUMERIC,2) AS avg_comm_load,
       ROUND(AVG(Collaboration_Load)::NUMERIC,2) AS avg_collab_load,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_productivity
FROM workspace_usage
GROUP BY Department, Week;
----NOTE-we can directly connect Power BI / Looker Studio to this view

--14.Meeting efficiency analysis
--Q14: Which departments achieve the highest productivity per meeting hour?
SELECT Department,
       ROUND((SUM(Productivity_Score) / NULLIF(SUM(Meetings_Hours),0))::NUMERIC,2) AS prod_per_meeting_hour
FROM workspace_usage
GROUP BY Department
ORDER BY prod_per_meeting_hour DESC;

--15.Peak collaboration weeks
--Q15: Which weeks had the highest collaboration activity overall?
SELECT Week,
       SUM(Collaboration_Load) AS total_collaboration,
       RANK() OVER (ORDER BY SUM(Collaboration_Load) DESC) AS rank_collab_week
FROM workspace_usage
GROUP BY Week
ORDER BY total_collaboration DESC
LIMIT 5;

--16.Productivity vs Communication load 
--Q16: Does high communication (emails) drive productivity or hinder it?
SELECT Department,
       ROUND(AVG(Communication_Load)::NUMERIC,2) AS avg_comm_load,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_productivity
FROM workspace_usage
GROUP BY Department
ORDER BY avg_comm_load DESC;

--17.Team consistency score
--Q17: Which departments are the most consistent (lowest variance) in productivity?
SELECT Department,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_prod,
       ROUND(STDDEV_POP(Productivity_Score)::NUMERIC,2) AS stddev_prod
FROM workspace_usage
GROUP BY Department
ORDER BY stddev_prod ASC;
----NOTE-Low stddev = stable teams, high stddev = volatile productivity.

--18.Productivity seasonality check
--Q18: Do productivity levels differ by month? (grouping weeks into months)
SELECT CASE 
         WHEN Week BETWEEN 1 AND 4 THEN 'Month 1'
         WHEN Week BETWEEN 5 AND 8 THEN 'Month 2'
         WHEN Week BETWEEN 9 AND 12 THEN 'Month 3'
         ELSE 'Other'
       END AS Month,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_productivity
FROM workspace_usage
GROUP BY Month
ORDER BY Month;

--19.Productivity deciles
--Q19: Divide employees into 10 bands by productivity.
WITH emp_avg AS (
  SELECT Employee_ID,
         AVG(Productivity_Score) AS avg_prod
  FROM workspace_usage
  GROUP BY Employee_ID
)
SELECT Employee_ID, avg_prod,
       NTILE(10) OVER (ORDER BY avg_prod DESC) AS productivity_decile
FROM emp_avg
ORDER BY productivity_decile, avg_prod DESC;
----NOTE-Useful for segmenting employees (top 10%, bottom 10%).

--20.Employee improvement champions
--Q20: Who improved productivity the most from their first to last observed week?
WITH prod_trends AS (
    SELECT Employee_ID,
           FIRST_VALUE(Productivity_Score) OVER (PARTITION BY Employee_ID ORDER BY Week) AS first_prod,
           LAST_VALUE(Productivity_Score) OVER (PARTITION BY Employee_ID ORDER BY Week ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_prod
    FROM workspace_usage
)
SELECT Employee_ID,
       ROUND(AVG(last_prod - first_prod)::NUMERIC,2) AS improvement
FROM prod_trends
GROUP BY Employee_ID
ORDER BY improvement DESC
LIMIT 10;

--21.Cross-metric correlation
--Q21: How are different metrics related?
SELECT 
   CORR(Communication_Load, Productivity_Score) AS corr_comm_prod,
   CORR(Collaboration_Load, Productivity_Score) AS corr_collab_prod,
   CORR(Meetings_Hours, Productivity_Score) AS corr_meet_prod
FROM workspace_usage;

--22.Cluster-ready feature scaling
--Q: Normalize features for machine learning (Z-scores).
WITH emp_avg AS (
  SELECT Employee_ID,
         AVG(Emails_Sent) AS avg_emails,
         AVG(Meetings_Hours) AS avg_meetings,
         AVG(Collaboration_Load) AS avg_collab,
         AVG(Productivity_Score) AS avg_productivity
  FROM workspace_usage
  GROUP BY Employee_ID
)
SELECT Employee_ID,
       (avg_emails - AVG(avg_emails) OVER()) / NULLIF(STDDEV_POP(avg_emails) OVER(),0) AS z_emails,
       (avg_meetings - AVG(avg_meetings) OVER()) / NULLIF(STDDEV_POP(avg_meetings) OVER(),0) AS z_meetings,
       (avg_collab - AVG(avg_collab) OVER()) / NULLIF(STDDEV_POP(avg_collab) OVER(),0) AS z_collab,
       (avg_productivity - AVG(avg_productivity) OVER()) / NULLIF(STDDEV_POP(avg_productivity) OVER(),0) AS z_productivity
FROM emp_avg;
----NOTE-Directly export this to Python for k-means clustering.

--23.Manager impact analysis
--(If you have a departments dimension with managers)
SELECT Department,
       ROUND(AVG(Productivity_Score)::NUMERIC,2) AS avg_team_productivity,
       ROUND(AVG(Meetings_Hours)::NUMERIC,2) AS avg_team_meetings
FROM workspace_usage
GROUP BY Department
ORDER BY avg_team_productivity DESC;





















