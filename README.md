##  **Employee Attrition and Retention Risk Analysis (SQL Server)**

### **1. The Challenge & Objective**

* **The challenge** was to address a high employee attrition rate impacting operational costs and work quality. A lack of clear insight into the underlying causes of employee departures rendered management interventions ineffective.

* **The Objective:** To utilize advanced SQL queries to clean and deeply analyze HR data, identify the **Key Drivers of Attrition**, and provide actionable, data-backed insights.

### **2. Methodology & Technical Stack**

The analysis model was built using SQL Server, emphasizing data integrity and analytical depth:

  * **Data Cleaning and Preprocessing:** Conducted comprehensive checks for missing values and standardized text formats (using `UPPER()` and `ALTER TABLE`) to ensure the accuracy of all subsequent queries.
  * **Advanced Analysis with `CASE` Statements:** Leveraged `CASE` expressions to segment employees into meaningful analytical groups (e.g., Experience Levels: `Junior`, `Mid`, `Senior`; and Service Duration groups) to calculate and analyze turnover rates by cohort.
  * **Composite Analysis:** Designed complex queries to correlate **Geographical Location (City)** with **Compensation Tier (Payment Tier)**, pinpointing specific employee segments and locations at the highest risk of departure.
  * **Temporal Metrics:** Calculated dynamic years of service (`YearsOfService`) for each employee to link tenure directly to attrition probability.

### **3. Key Insights & Actionable Findings**

The SQL analysis unearthed critical vulnerabilities in the employee retention strategy:

  * **New Hire Risk:** Tenure analysis revealed that new employees with less than two years of service exhibit the highest turnover rate, indicating an urgent need to improve the initial onboarding and integration process.
  * **Impact of "Benched" Status:** Data demonstrated that employees categorized as "Ever Benched" are leaving at a significantly higher rate than their counterparts, necessitating immediate solutions to engage and assign them to projects.
  * **Combined Geographical Threat:** Specific cohorts of mid-tier employees (Payment Tier 2) in certain cities were identified as having the highest combined attrition rate, providing management with a clearly defined target for intervention (Specific Intervention Target).

### **4. Examples of Advanced SQL Queries**

These queries demonstrate the ability to transform raw data into actionable business segments:

1.  **Advanced Grouping Query (Turnover by Service Duration):**

      * This query uses the `CASE` statement to bucket employees by tenure, a crucial step for retention strategy.

    <!-- end list -->

    ```sql
    SELECT
        CASE
            WHEN (YEAR(GETDATE()) - JoiningYear) < 3 THEN '0-2 Years'
        END AS ServiceGroup,
        ROUND(100.0 * SUM(CASE WHEN LeaveOrNot = 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS TurnoverRate
    FROM Employees;
    ```

2.  **Composite Analysis Query (Impact of City and Payment Tier):**

      * This query combines two critical dimensions to find complex attrition patterns, showcasing advanced grouping skills.

    <!-- end list -->

    ```sql
    SELECT 
        City,
        PaymentTier,
        (SUM(LeaveOrNot) * 100.0 / COUNT(*)) AS LeaveRate
    FROM Employees
    GROUP BY City, PaymentTier
    ORDER BY LeaveRate DESC;
    ```
