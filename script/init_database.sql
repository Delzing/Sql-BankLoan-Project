-- This script answers key questions regarding the bank loan business transactions


SELECT * from [dbo].[bank_loan_data]

--Display the total loan applications 
select count(id) as Total_Loan_Applications
 from bank_loan_data

--Display the MTD Loan Application 
select count(id) as MTD_Total_Loan_Applications
from bank_loan_data
where month(issue_date) = 12 

--Display the PMTD Loan Application 
select count(id) as PMTD_Total_Loan_Applications
from bank_loan_data
where month(issue_date) = 11 

--Total Funded Amount 
select sum(loan_amount) as Total_Funded_Amount
from bank_loan_data

--MTD Total Funded Amount
select sum(loan_amount) as MTD_Total_Funded_Amount
from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

--PMTD Total Funded Amount
select sum(loan_amount) as PMTD_Total_Funded_Amount
from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

--Total Amount returned to the bank
select sum(total_payment) from bank_loan_data as Total_Amount_Returned 

--MTD Total Amount Returned
select sum(total_payment) as MTD_Total_Amount_Returned
from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

--PMTD Total Amount Returned 
select sum(total_payment) as PMTD_Total_Amount_Returned
from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

--Average interest rate (MTD)
select round(avg(int_rate)* 100, 2) as MTD_Avg_Interest_Rate
from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

--Average interest rate (PMTD)
select round(avg(int_rate)* 100, 2) as PMTD_Avg_Interest_Rate 
from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021

--Average Debt-to-income Ration (MTD)
select round(AVG(dti) * 100, 2) as MTD_Avg_DTI
from bank_loan_data
where month(issue_date) = 12 and year(issue_date) = 2021

--Average Debt-to-income Ration (PMTD)
select round(AVG(dti) * 100, 2) as PMTD_Avg_DTI
from bank_loan_data
where month(issue_date) = 11 and year(issue_date) = 2021


--GOOD LOANS vs BAD LOAN
select distinct loan_status from bank_loan_data

-- Good Loan Application Percentage
select
	(count (case
		when loan_status = 'Fully Paid' OR loan_status = 'Current'
		then id 
		end) * 100)
		/
		count (id) as Good_Loan_Percentage
from bank_loan_data 

-- Total Number Good Loan Applications
select count (id) as Good_Loan_Application 
from bank_loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current'

-- Good Loan Funded Amount 
select sum (loan_amount) as Good_Loan_Funded_Amount
from bank_loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current'

-- Total Amount Retured 
select sum (total_payment) as Good_Loan_Returned 
from bank_loan_data
where loan_status = 'Fully Paid' OR loan_status = 'Current'

-- Total Percentage of Bad loan
select
	(count (case
		when loan_status = 'Charged Off'
		then id 
		end) * 100)
		/
		count (id) as Bad_Loan_Percentage
from bank_loan_data 

-- Total Number Bad Loan Applications
select count (id) as Bad_Loan_Application 
from bank_loan_data
where loan_status = 'Charged Off'

-- Bad Loan Funded Amount 
select sum (loan_amount) as Bad_Loan_Funded_Amount
from bank_loan_data
where loan_status = 'Charged Off'

-- Total Amount Retured 
select sum (total_payment) as Bad_Loan_Returned 
from bank_loan_data
where loan_status = 'Charged Off'

-- LOAN STATUS GRID VIEW

/* The loan status grid view will empower stakeholders to 
make data-driven decisions and assess the health of loan portfolio.
Fully Paid and Current are good loans while Charged Off are bad loans
*/

select 
	loan_status,
	count(id) as Total_Loan_Applicaions,
	sum(total_payment) as Total_Amount_Received,
	sum(loan_amount) as Total_Funded_Amount,
	round(avg(int_rate * 100), 2) as Interest_Rate,
	round(avg(dti * 100), 2) as dti
from
	bank_loan_data
group by
	loan_status

--MTD Amount Loan vs Amount Returned 
select
	loan_status,
	sum(total_payment) as MTD_Total_Amount_Received,
	sum(loan_amount) as MTD_Total_Funded_Amount
from bank_loan_data
where month(issue_date) = 12
group by loan_status 

-- Monthly Loan Status 
select
	month(issue_date) as Month_Number,
	DATENAME(month, issue_date),
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by month(issue_date), DATENAME(month, issue_date)
order by month(issue_date)


-- Loan Status By State
select
	address_state,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by address_state
order by count(id) desc

-- Loan Status by Loan Term
select
	term,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by term
order by term

-- Loan Status By Length of Employment 
select
	emp_length,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by emp_length
order by count(id) desc

-- Loan Status By Purpose
select
	purpose,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by purpose
order by count(id) desc

-- Loan Status By Home Ownership
select
	home_ownership,
	count(id) as Total_Loan_Applications,
	sum(loan_amount) as Total_Funded_Amount,
	sum(total_payment) as Total_Received_Amount
from bank_loan_data
group by home_ownership
order by count(id) desc
