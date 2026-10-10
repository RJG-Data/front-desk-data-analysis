-- Question 1: How accurate are we at capturing data correctly for Walk-Ins?

-- Total Walk-Ins by Month

SELECT Month, COUNT(*) AS Total_Walk_Ins
FROM '2026_Data_Report_Jan_thru_Aug_Front_Desk'
WHERE Method = 'Walk in'
GROUP BY Month
ORDER BY Date ASC;

-- Completed Language Walk-Ins by Month

SELECT Month, COUNT(Language) AS Completed_Walk_Ins
FROM '2026_Data_Report_Jan_thru_Aug_Front_Desk'
WHERE Method = 'Walk in'
GROUP BY Month
ORDER BY Date ASC;

-- % of Completed Walk-Ins by Month (Completed / Total)

SELECT
    Month,
    COUNT(*) AS Total_Walk_Ins,
    COUNT(Language) AS Completed_Language_Walk_Ins,
    ROUND(COUNT(Language) * 100.0 / COUNT(*), 2) AS Completion_Rate_Pct
FROM '2026_Data_Report_Jan_thru_Aug_Front_Desk'
WHERE Method = 'Walk in'
GROUP BY Month
ORDER BY Date ASC;


-- Question 2: What are the primary languages spoken at the front desk From Jan-Aug?

-- Overall Language Counts And % of Language Spoken

SELECT 
    Language, 
    COUNT(Language) AS Total_Contacts,
    ROUND(COUNT(Language) * 100.0 / 
	(
		SELECT COUNT(Language) 
		FROM '2026_Data_Report_Jan_thru_Aug_Front_Desk' 
		WHERE Language IS NOT NULL), 2) AS Percentage
FROM '2026_Data_Report_Jan_thru_Aug_Front_Desk'
WHERE Language IS NOT NULL
GROUP BY Language
ORDER BY Total_Contacts DESC;


-- Question 3: Which departments do Parents and Providers reach out to the most from Jan-Aug?

-- Parent and Provider Breakdown for the top 6 departments (with Null departments excluded)

SELECT 
    Department,
    COUNT(CASE WHEN "Parent or Provider" = 'Parent' THEN 1 END) AS Parent_Count,
    COUNT(CASE WHEN "Parent or Provider" = 'Provider' THEN 1 END) AS Provider_Count,
    COUNT(*) AS Total_Count
FROM '2026_Data_Report_Jan_thru_Aug_Front_Desk'
GROUP BY Department
ORDER BY Total_Count DESC
LIMIT 6
OFFSET 1;


-- Question 4: Which Departments Show the Steepest Decline in Customer Service Scores in The Last 3 Months (Jun-Aug)?

-- Identify the 3 Departments with the Most Service Misses

SELECT Department, COUNT(*) AS Service_Misses_Count
FROM '2026_Data_Report_Jan_thru_Aug_Front_Desk'
WHERE "Service Misses" = 'Yes'
GROUP BY Department
ORDER BY Service_Misses_Count DESC
LIMIT 3;

-- Monthly Satisfaction and Service Miss Rates for Top 3 Departments (Jun-Aug)

SELECT
    Department,
    Month,
    COUNT(*) AS Total_Interactions,
    COUNT(CASE WHEN "Service Misses" = 'Yes' THEN 1 END) AS Service_Misses_Count,
    ROUND(COUNT(CASE WHEN "Service Misses" = 'Yes' THEN 1 END) * 100.0 / COUNT(*), 2) AS Miss_Rate_Pct,
    ROUND(COUNT(CASE WHEN "Service Misses" = 'No' THEN 1 END) * 100.0 / COUNT(*), 1) AS Satisfaction_Rate_Pct
FROM '2026_Data_Report_Jan_thru_Aug_Front_Desk'
WHERE department IN ('Dept_002', 'Dept_005', 'Dept_008') AND Date >= '2026-06-01' AND Date <= '2026-08-31'
GROUP BY Department, Month
ORDER BY Month DESC;