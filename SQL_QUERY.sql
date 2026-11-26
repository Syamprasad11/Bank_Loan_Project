create database Bank_Loan;
use Bank_loan;

select * from Loan;


-- =====================================================
-- PROJECT: BANK LOAN AND RISK ANALYSIS
-- TOOL: MYSQL
-- PURPOSE: BUSINESS-ORIENTED SQL ANALYSIS
-- =====================================================


-- =====================================================
-- 1. KPI ANALYSIS
-- =====================================================

-- Q1. What is the total number of loan applications?
select count(distinct(id)) as Total_Number_of_Applications from Loan;

-- Q2. What is the total funded loan amount?
select sum(loan_amount) as Total_Funded_Loan_Amount from loan;

-- Q3. What is the total amount received from borrowers?
select sum(total_payment) as Total_Amount_Received from Loan;

-- Q4. What are the average loan amount, average interest rate,
--     and average debt-to-income ratio (DTI)?
select round(avg(loan_amount),2) as Avg_Loan_Amount,round(avg(int_rate),2) as Avg_Interest_Rate,round(avg(dti),2) as Avg_Debt_to_Income from Loan;

-- =====================================================
-- 2. CATEGORY ANALYSIS
-- =====================================================

-- Q5. Which loan purpose has the highest number of applications?
select purpose,count(id) as Number_of_Applications from Loan group by purpose order by Number_of_Applications desc;

-- Q6. Which credit grade has the highest number of loan applications?
select credit_grade,count(id) as Number_of_Applications from Loan group by credit_grade order by Number_of_Applications desc;

-- Q7. Which are the top 10 states based on loan applications?
select address_state,count(id) as Number_of_Applications,sum(loan_amount) as Total_Funded_Loan_amount from Loan group by address_state order by Number_of_Applications desc limit 10;

-- Q8. What is the total funded loan amount for each loan purpose?
select purpose,sum(loan_amount) as Total_Funded_Loan_amount from Loan group by purpose order by Total_Funded_Loan_amount desc;

-- =====================================================
-- 3. CUSTOMER ANALYSIS
-- =====================================================

-- Q9. Which home ownership category has the highest number of borrowers?
select home_ownership,count(member_id) as No_of_Borrowers from Loan group by home_ownership order by No_of_Borrowers desc;

-- Q10. What is the average annual income for each employment length category?
select emp_length,round(avg(annual_income),2) as Avg_annual_income from Loan group by emp_length;

-- Q11. Which income category has the highest total loan amount?
select income_category,sum(loan_amount) as Total_Loan_Amount from Loan group by income_category order by  Total_Loan_Amount desc;

-- Q12. What is the average loan amount for each verification status?
select verification_status,round(avg(loan_amount),2) as Avg_Loan_Amount from loan group by Verification_status;

-- =====================================================
-- 4. LOAN PERFORMANCE ANALYSIS
-- =====================================================

-- Q13. How many loans are Fully Paid, Current, and Charged Off?
select loan_status,count(member_id) Number_of_Applications from loan group by loan_status;

-- Q14. What percentage of loans are Good Loans, Bad Loans,
--      and Active Loans?
select loan_status_group,count(id) as Number_of_Applications,round(count(id) * 100 / (select count(*) from Loan),2) as Percentage_of_Loan from Loan group by loan_status_group order by Number_of_Applications desc;

-- Q15. What is the total amount received for each loan status?
select loan_status,sum(loan_amount) as Total_Loan_Amount,round(avg(total_payment), 2) as Average_Amount_Received from Loan group by loan_status;

-- Q16. What are the monthly loan application trends?
select Monthname(issue_date) as Month ,count(id) as Number_of_Applications,sum(loan_amount) as Total_Loan_Amount,sum(total_payment) as Total_Amount_Rececived from Loan group by Monthname(issue_date) order by Number_of_Applications;

-- =====================================================
-- 5. RISK ANALYSIS
-- =====================================================

-- Q17. Which credit grade has the highest charged-off rate
--      among resolved loans?
select credit_grade,count(case when loan_status in ("Fully paid","Charged Off") then id end) as Resolved_Loans,count(case when loan_status="Charged Off" then id end) as Charged_Off_Loans,count(case when loan_status="Charged Off" then id end)*100 /count(case when loan_status in ("Fully paid","Charged Off") then id end) as Charged_Off_Rate  from Loan group by credit_grade order by Charged_Off_Rate desc;

-- Q18. Which loan purpose has the highest charged-off rate
--      among resolved loans?
select purpose,count(case when loan_status in ("Fully paid","Charged Off") then id end) as Resolved_Loans,count(case when loan_status="Charged Off" then id end) as Charged_Off_Loans,count(case when loan_status="Charged Off" then id end)*100 /count(case when loan_status in ("Fully paid","Charged Off") then id end) as Charged_Off_Rate  from Loan group by purpose order by Charged_Off_Rate desc;

-- Q19. What is the average DTI for each loan status?
select loan_status,round(avg(dti),2) as Avg_Debit_to_Income from loan group by loan_status;

-- Q20. Rank credit grades based on their charged-off rates.
with Chargedoffrate as(
select credit_grade,count(case when loan_status in ("Fully paid","Charged Off") then id end) as Resolved_Loans,count(case when loan_status="Charged Off" then id end) as Charged_Off_Loans,count(case when loan_status="Charged Off" then id end)*100 /count(case when loan_status in ("Fully paid","Charged Off") then id end) as Charged_Off_Rate  from Loan group by credit_grade order by Charged_Off_Rate desc
)
select credit_grade,Resolved_Loans,Charged_Off_Loans,Charged_Off_Rate,rank() over(order by Charged_Off_Rate desc) as Ranked_based_on_charged_off_rate from Chargedoffrate;

-- =====================================================
-- END OF BUSINESS ANALYSIS QUESTIONS
-- =====================================================

