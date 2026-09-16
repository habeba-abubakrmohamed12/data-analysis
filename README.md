# data-analysis
data analysis
Student Performance & Engagement Analytics
📌 Overview
End-to-end data analytics project analyzing 40,000 student records to uncover
factors driving academic success and engagement. Built as part of the
Alex The Analyst Data Analyst Bootcamp.
🛠 Tech Stack
Excel: Initial data review and pivot table exploration
Python: Pandas, NumPy, Matplotlib, Seaborn for EDA & cleaning
SQL: SQLite for analytical queries (CTEs, Window Functions)
Power BI: Interactive dashboard with DAX measures
GitHub: Version control and project documentation
AWS: (Optional) S3 for data storage, RDS for database hosting
📂 Project Structure
```
student-performance-analytics/
│
├── data/
│   ├── raw/
│   │   └── student_performance_data.xlsx   # Original Excel file (generated)
│   └── processed/
│       ├── cleaned_data.csv                # After Python cleaning
│       ├── sql_ready_data.csv              # For database import
│       ├── at_risk_students.csv            # At-risk student list (from SQL)
│       └── regional_summary.csv            # Region performance gap (from SQL)
│
├── notebooks/
│   ├── 01_data_exploration.ipynb           # Python EDA & cleaning
│   ├── 02_sql_analysis.ipynb               # SQL queries via SQLite
│   └── 03_visualization_export.ipynb       # Validation + Power BI prep
│
├── sql/
│   └── analysis_queries.sql                # All SQL scripts
│
├── powerbi/
│   └── student_dashboard.pbix              # Power BI report file (built manually)
│
├── docs/
│   ├── project_report.md                   # Final write-up
│   └── dashboard_preview.png               # Static dashboard layout preview
│
└── README.md
```
🚀 How to Run
Clone the repository
Open `notebooks/01_data_exploration.ipynb` and run all cells
Open `notebooks/02_sql_analysis.ipynb` and run all cells
Open `notebooks/03_visualization_export.ipynb` and run all cells
Open Power BI Desktop, import the three CSVs from `data/processed/` per
the Power BI Dashboard Guide, and build `powerbi/student_dashboard.pbix`
📈 Key Insights
Engagement correlates with performance but isn't deterministic: video
completion rate (r ≈ 0.47) is a stronger signal than login count (r ≈ 0.36).
Students in the "High" engagement tier average 73.1% vs. 61.3% for "Low" —
an 11.8-point gap.
Region performance gap is 10.5 points: East Asia averages 71.8%, Africa
averages 61.3%.
Subject performance gap is 6.8 points: Computer Science averages 70.5%,
Mathematics averages 63.7% — the weakest subject across every region.
9,595 students (24%) meet the at-risk definition (low engagement + below-average
score); the at-risk rate is nearly double in Africa (30.1%) compared to East
Asia (17.7%), suggesting regional targeting for interventions.
See `docs/project_report.md` for the full write-up.
