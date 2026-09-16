# Student Performance & Engagement Analytics — Project Report

## 1. Executive Summary
This project analyzed 40,000 student records on an EdTech platform to
identify what drives academic performance and engagement. Engagement
metrics — particularly video completion rate — show a real, moderate
relationship with performance, but region and subject explain a comparable
amount of the gap, meaning engagement alone doesn't fully account for who
succeeds. Roughly a quarter of students (24%) meet a simple, reproducible
at-risk definition, with that rate nearly doubling in the lowest-performing
region compared to the highest. These patterns point to two levers for the
EdTech company: engagement-focused interventions (especially around video
content) and region/subject-targeted support, particularly for Mathematics
and for students in Africa and South Asia.

## 2. Problem Statement
The manager asked for an analysis answering four questions:
1. How does student engagement (app logins, video completion) correlate with
   academic performance?
2. Which subjects and regions show the biggest performance gaps?
3. Can at-risk students be identified early from engagement patterns?
4. What would an interactive dashboard tracking these KPIs look like for
   stakeholders?

## 3. Data Description
- **Source**: synthetic dataset generated for this project (`data/raw/student_performance_data.xlsx`),
  designed to reflect realistic relationships between engagement and
  performance, including built-in region/subject effects and natural noise —
  it is not real student data.
- **Size**: 40,025 raw rows (25 intentional duplicate rows) → 40,000 rows
  after cleaning.
- **Columns**: Student_ID, Region (6), Subject (6), Gender, Grade_Level (9-12),
  Age, App_Login_Count, Video_Completion_Rate, Study_Hours_Per_Week,
  Assignment_Submission_Rate, Percentage (academic score), Engagement_Level
  (Low/Medium/High, derived from login count + video completion).
- **Limitations**: synthetic data — relationships are realistic by design but
  don't capture the noisiness or confounds of real student behavior; 1.5% of
  `Video_Completion_Rate` values were missing and imputed with the
  subject-level median rather than observed directly.

## 4. Methodology
| Stage | Tool | What happened |
|---|---|---|
| Data generation | Python (NumPy/Pandas) | Synthetic dataset built with deliberate engagement→performance and region/subject effects |
| Cleaning & EDA | Python (Pandas, Matplotlib, Seaborn) | Removed 25 duplicate students, imputed missing values, ran correlation and group analysis |
| Analytical queries | SQL (SQLite) | Reproduced and extended the Python analysis using CTEs and window functions; exported at-risk and regional summary tables |
| Dashboard prep | Python | Validated the three Power BI import files; built a static layout preview |
| Dashboard build | Power BI Desktop | Manual build using the DAX measures and import steps in the Power BI Dashboard Guide |

## 5. Key Insights
- **Video completion rate is the stronger engagement signal** (r ≈ 0.47 with
  Percentage) compared to login count (r ≈ 0.36) — showing up, without
  finishing content, matters less than finishing it.
- **Engagement tiers separate cleanly on outcomes**: High-engagement students
  average 73.1%, Medium 66.7%, Low 61.3%.
- **Region gap is 10.5 points**: East Asia (71.8%) highest, Africa (61.3%)
  lowest, with North America, Europe, and South America in between.
- **Subject gap is 6.8 points**: Computer Science (70.5%) highest, Mathematics
  (63.7%) lowest — Mathematics trails in every region, not just on average.
- **24% of students (9,595) are at-risk** under a low-engagement +
  below-average-score definition applied consistently across the Python, SQL,
  and Power BI layers.
- **At-risk rate is regionally concentrated**: 30.1% in Africa vs. 17.7% in
  East Asia — nearly double, meaning a flat, non-regional intervention
  strategy would over-serve some regions and under-serve others.
- **Region and subject effects are comparable in size to the engagement
  effect**, which means engagement campaigns alone likely won't close the
  full performance gap — curriculum or resourcing differences by
  region/subject are worth investigating directly.

## 6. Recommendations
1. **Prioritize video-based engagement nudges** over generic login prompts,
   since completion rate is the stronger of the two engagement signals.
2. **Target early-intervention outreach by region**, starting with Africa and
   South Asia, where at-risk rates are highest.
3. **Investigate Mathematics specifically** — its consistent underperformance
   across every region suggests a subject-level issue (content difficulty,
   pacing, or instructional format) rather than a regional one.
4. **Operationalize the at-risk flag** (Low engagement + below-average score)
   as a recurring, automated report — it's cheap to compute and already
   validated across three tools (Python, SQL, Power BI).
5. **Track the KPIs in this report on a recurring cadence** (e.g., monthly)
   via the Power BI dashboard, so region/subject gaps and at-risk counts can
   be monitored as interventions roll out, not just measured once.

## 7. Appendix
- SQL queries: `sql/analysis_queries.sql`
- Python notebooks: `notebooks/01_data_exploration.ipynb`,
  `notebooks/02_sql_analysis.ipynb`, `notebooks/03_visualization_export.ipynb`
- Dashboard layout preview: `docs/dashboard_preview.png`
- Data generation script (documents all synthetic-data assumptions):
  `scripts_generate_data.py`
