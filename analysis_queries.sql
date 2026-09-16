-- ============================================================================
-- Student Performance & Engagement Analytics — SQL Analysis Queries
-- Target: SQLite, table `students` loaded from data/processed/sql_ready_data.csv
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. Overview
-- ----------------------------------------------------------------------------
SELECT
    COUNT(*) AS total_students,
    ROUND(AVG(percentage), 1) AS avg_percentage,
    ROUND(AVG(app_login_count), 1) AS avg_login_count,
    ROUND(AVG(video_completion_rate), 1) AS avg_video_completion
FROM students;


-- ----------------------------------------------------------------------------
-- 2. Engagement vs. performance
-- Business question: how does engagement correlate with academic performance?
-- ----------------------------------------------------------------------------
SELECT
    engagement_level,
    COUNT(*) AS num_students,
    ROUND(AVG(percentage), 1) AS avg_percentage,
    ROUND(AVG(app_login_count), 1) AS avg_login_count,
    ROUND(AVG(video_completion_rate), 1) AS avg_video_completion
FROM students
GROUP BY engagement_level
ORDER BY avg_percentage DESC;


-- ----------------------------------------------------------------------------
-- 3. Region performance gap (CTE)
-- Business question: which regions show the biggest performance gaps?
-- ----------------------------------------------------------------------------
WITH region_stats AS (
    SELECT
        region,
        COUNT(*) AS num_students,
        AVG(percentage) AS avg_percentage
    FROM students
    GROUP BY region
)
SELECT
    region,
    num_students,
    ROUND(avg_percentage, 1) AS avg_percentage,
    ROUND(avg_percentage - (SELECT MIN(avg_percentage) FROM region_stats), 1) AS gap_above_lowest,
    ROUND((SELECT MAX(avg_percentage) FROM region_stats)
        - (SELECT MIN(avg_percentage) FROM region_stats), 1) AS overall_region_gap
FROM region_stats
ORDER BY avg_percentage DESC;


-- ----------------------------------------------------------------------------
-- 4. Subject performance gap (CTE)
-- Business question: which subjects show the biggest performance gaps?
-- ----------------------------------------------------------------------------
WITH subject_stats AS (
    SELECT
        subject,
        COUNT(*) AS num_students,
        AVG(percentage) AS avg_percentage
    FROM students
    GROUP BY subject
)
SELECT
    subject,
    num_students,
    ROUND(avg_percentage, 1) AS avg_percentage,
    ROUND(avg_percentage - (SELECT MIN(avg_percentage) FROM subject_stats), 1) AS gap_above_lowest
FROM subject_stats
ORDER BY avg_percentage DESC;


-- ----------------------------------------------------------------------------
-- 5. Region rank within each subject (CTE + window function)
-- ----------------------------------------------------------------------------
WITH region_subject_avg AS (
    SELECT
        subject,
        region,
        AVG(percentage) AS avg_percentage
    FROM students
    GROUP BY subject, region
)
SELECT
    subject,
    region,
    ROUND(avg_percentage, 1) AS avg_percentage,
    RANK() OVER (PARTITION BY subject ORDER BY avg_percentage DESC) AS rank_in_subject
FROM region_subject_avg
ORDER BY subject, rank_in_subject;


-- ----------------------------------------------------------------------------
-- 6. At-risk students (CTE)
-- Business question: can we identify at-risk students early?
-- Definition: Low engagement AND below the overall average score.
-- Mirrors the Power BI "At-Risk Count" DAX measure so all three layers agree.
-- ----------------------------------------------------------------------------
WITH overall AS (
    SELECT AVG(percentage) AS avg_percentage FROM students
)
SELECT
    student_id,
    region,
    subject,
    engagement_level,
    percentage,
    app_login_count,
    video_completion_rate
FROM students, overall
WHERE engagement_level = 'Low'
  AND percentage < overall.avg_percentage
ORDER BY percentage ASC;


-- ----------------------------------------------------------------------------
-- 7. At-risk rate by region (CTE)
-- Where should early-intervention efforts focus first?
-- ----------------------------------------------------------------------------
WITH overall AS (
    SELECT AVG(percentage) AS avg_percentage FROM students
),
flagged AS (
    SELECT students.*,
        CASE WHEN engagement_level = 'Low' AND percentage < overall.avg_percentage
             THEN 1 ELSE 0 END AS at_risk
    FROM students, overall
)
SELECT
    region,
    COUNT(*) AS total_students,
    SUM(at_risk) AS at_risk_students,
    ROUND(100.0 * SUM(at_risk) / COUNT(*), 1) AS at_risk_pct
FROM flagged
GROUP BY region
ORDER BY at_risk_pct DESC;


-- ----------------------------------------------------------------------------
-- 8. Percentile rank within subject (window function)
-- Useful for a "how does this student compare to peers in the same subject" view.
-- ----------------------------------------------------------------------------
SELECT
    student_id,
    subject,
    percentage,
    ROUND(PERCENT_RANK() OVER (PARTITION BY subject ORDER BY percentage), 3) AS pct_rank_in_subject
FROM students
ORDER BY subject, percentage;
