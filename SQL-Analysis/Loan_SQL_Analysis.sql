
-- Loan Origination System – SQL Analysis
-- Domain: Retail Lending
-- Author: Suresh Chandrasekar (BA Portfolio)

-- Table: loan_applications
-- Columns:
-- application_id, customer_id, loan_type, loan_amount, tenure_months,
-- monthly_income, existing_emi, cibil_score, employment_type,
-- application_status, region, created_date

------------------------------------------------------------
-- 1. Total Applications
SELECT COUNT(*) AS total_applications
FROM loan_applications;

------------------------------------------------------------
-- 2. Approved vs Rejected Applications
SELECT application_status, COUNT(*) AS count
FROM loan_applications
GROUP BY application_status;

------------------------------------------------------------
-- 3. Approval Rate
SELECT 
    SUM(CASE WHEN application_status = 'Approved' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) 
    AS approval_rate_percentage
FROM loan_applications;

------------------------------------------------------------
-- 4. Average Loan Amount by Loan Type
SELECT loan_type, AVG(loan_amount) AS avg_loan_amount
FROM loan_applications
GROUP BY loan_type;

------------------------------------------------------------
-- 5. CIBIL Score Distribution
SELECT 
    CASE 
        WHEN cibil_score < 650 THEN 'Low'
        WHEN cibil_score BETWEEN 650 AND 749 THEN 'Medium'
        ELSE 'High'
    END AS cibil_category,
    COUNT(*) AS applicant_count
FROM loan_applications
GROUP BY 
    CASE 
        WHEN cibil_score < 650 THEN 'Low'
        WHEN cibil_score BETWEEN 650 AND 749 THEN 'Medium'
        ELSE 'High'
    END;

------------------------------------------------------------
-- 6. High-Risk Customers (CIBIL < 650 OR FOIR > 50%)
SELECT application_id, customer_id, cibil_score,
       (existing_emi * 100.0 / monthly_income) AS foir_percentage
FROM loan_applications
WHERE cibil_score < 650
   OR (existing_emi * 100.0 / monthly_income) > 50;

------------------------------------------------------------
-- 7. Region-wise Loan Applications
SELECT region, COUNT(*) AS total_applications
FROM loan_applications
GROUP BY region
ORDER BY total_applications DESC;

------------------------------------------------------------
-- 8. Average FOIR by Loan Type
SELECT loan_type,
       AVG(existing_emi * 100.0 / monthly_income) AS avg_foir_percentage
FROM loan_applications
GROUP BY loan_type;

------------------------------------------------------------
-- 9. Top 5 Highest Loan Amount Applications
SELECT application_id, customer_id, loan_amount
FROM loan_applications
ORDER BY loan_amount DESC
LIMIT 5;

------------------------------------------------------------
-- 10. Monthly Application Trend
SELECT DATE_TRUNC('month', created_date) AS application_month,
       COUNT(*) AS total_applications
FROM loan_applications
GROUP BY DATE_TRUNC('month', created_date)
ORDER BY application_month;
