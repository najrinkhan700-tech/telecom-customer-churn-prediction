CREATE DATABASE telecomChurnDB;
use telecomChurnDB;

select top 10 * from [Telco-Customer-Churn];


-- 1. What is the total number of customers in the dataset?
SELECT COUNT(*) as Total_customers
from [Telco-Customer-Churn] ;



-- 2. What percentage of customers have churned vs retained?
SELECT churn ,
	COUNT(*) as Customers_count,
	ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM [Telco-Customer-Churn]), 2) AS percentage
from [Telco-Customer-Churn]
group by churn;



-- 3. Which contract type (month-to-month, one year, two year) has the highest churn rate?
SELECT contract,
	   COUNT(*) AS Total_customers,
	   SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) as churned_customers,
	   ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*) ,2) AS churn_rate_percent
FROM [Telco-Customer-Churn]
group by contract
order by churn_rate_percent DESC;



-- 4. What is the average tenure of churned customers compared to retained customers?
SELECT 
    churn,
    ROUND(AVG(tenure), 2) AS avg_tenure_months,
    COUNT(*) AS customer_count
FROM [Telco-Customer-Churn]
GROUP BY churn;



-- 5. Which payment method has the highest churn rate?
SELECT
	payment_method,
    COUNT(*) AS total_customers,
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
	ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS churn_rate_percent	
FROM [Telco-Customer-Churn]
GROUP BY payment_method
ORDER BY churn_rate_percent DESC;	



-- 6. Do senior citizens churn more than non-senior citizens?
SELECT
	senior_citizen,
	COUNT(*) AS Total_customers,
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
	ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS churn_rate_percent 
FROM [Telco-Customer-Churn]
GROUP BY senior_citizen
ORDER BY churn_rate_percent DESC;



-- 7. Who are the top 10 customers by monthly charges?
SELECT TOP 10
	customer_id,
	monthly_charges,
	tenure,
	contract,
	churn
FROM [Telco-Customer-Churn]
WHERE churn = 'Yes'
ORDER BY monthly_charges DESC;



-- 8. Which internet service type (DSL, Fiber optic, No internet) has the highest churn rate and average monthly charges?
SELECT 
    internet_service,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
    ) AS churn_rate_percent,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges
FROM [Telco-Customer-Churn]
GROUP BY internet_service
ORDER BY churn_rate_percent DESC;



-- 9. Do customers with zero additional services (no online security, no tech support, etc.) churn more than customers with multiple services?
with summary_services AS (
	SELECT 
		customer_id,
		(CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
		 CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
		 CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
		 CASE WHEN tech_support = 'Yes' THEN 1 ELSE 0 END +
		 CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
		 CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END) AS num_services
FROM [Telco-Customer-Churn] 
)	
SELECT 
	(CASE WHEN num_services = 0 THEN 'Zero Services' ELSE 'One or More Services' END) AS service_group,
	COUNT(*) AS total_customers,
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) AS churned_customers,
	ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END ) * 100.0 / COUNT(*),2) AS churn_rate_percent
from [Telco-Customer-Churn]
GROUP BY CASE WHEN num_services = 0 THEN 'Zero Services' ELSE 'One or More Services' END
ORDER BY churn_rate_percent DESC;

 

-- 10. What is the churn rate across different tenure groups (0-12, 13-24, 25-48, 49-60, 60+ months)?
SELECT
	CASE 
		WHEN tenure <= 12 THEN '0-12'
		WHEN tenure <= 24 THEN '13-24'
		WHEN tenure <= 48 THEN '25-48'
		WHEN tenure <= 60 THEN '49-60'
		ELSE '60+'
	END AS tenure_group,
	COUNT(*) AS total_customers,
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
	ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS	churned_rate_percent
FROM [Telco-Customer-Churn]
GROUP BY CASE 
        WHEN tenure <= 12 THEN '0-12'
        WHEN tenure <= 24 THEN '13-24'
        WHEN tenure <= 48 THEN '25-48'
        WHEN tenure <= 60 THEN '49-60'
        ELSE '60+' END
ORDER BY ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) DESC;


-- 11. Does paperless billing affect churn rate?
SELECT paperless_billing,
	COUNT(*) AS total_customers,
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customwers,
	ROUND(SUM(CASE WHEN churn = 'YES' THEN 1 ELSE 0 END) * 100 / COUNT(*),2) AS churn_rate_percent
FROM [Telco-Customer-Churn]
GROUP BY paperless_billing
ORDER BY churn_rate_percent DESC;



-- 12. What is the average monthly charge of churned vs retained customers?
SELECT churn,
	  ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges,
	  COUNT(*) AS customer_count
FROM [Telco-Customer-Churn]
group by churn;



-- 13. Which combination of contract type and internet service has the highest churn rate?
SELECT contract,
	internet_service,
	COUNT(*) AS total_customers,
	SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
	ROUND(SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS churn_rate_percent
FROM [Telco-Customer-Churn]
GROUP BY contract, internet_service
ORDER BY churn_rate_percent DESC;



-- 14. What percentage of customers have multiple lines, and does that affect churn?
SELECT 
    multiple_lines,
    COUNT(*) AS total_customers,
    ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM [Telco-Customer-Churn]), 2) AS percentage_of_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2
    ) AS churn_rate_percent
FROM [Telco-Customer-Churn]
GROUP BY multiple_lines
ORDER BY churn_rate_percent DESC;



-- 15. Is there a difference in churn rate between customers with and without a partner/dependents?
SELECT 
    partner,
    dependents,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2
    ) AS churn_rate_percent
FROM [Telco-Customer-Churn]
GROUP BY partner, dependents
ORDER BY churn_rate_percent DESC;