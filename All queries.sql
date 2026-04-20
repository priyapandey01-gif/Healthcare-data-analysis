
use project;

-- total no of patient
select count(*) as patient_number
from healthcare;

-- gender wise patient count
select Gender, count(*) as patient_count
FROM healthcare
group by Gender;

-- most common medical condition
select medical_condition, count(*) as total_cases
from healthcare
group by medical_condition
order by total_cases desc;

-- Age wise patient distribution
select Age, count(*) as total_patient
from healthcare
group by age
order by age desc;

-- Age group wise patient distribution
select                                    
case
when age< 18 then "under age"
when age between 18 and  35 then "18-35"
when age between 36 and 60 then  "36-60"
else "above age"
end as age_group,
 count(*) as total_patient
    from healthcare 
group by age_group
order by total_patient desc;


-- Average billing amount by medical condition
select medical_condition, round(avg(billing_amount),2) as avg_bill
from healthcare
group by medical_condition
order by avg_bill;


--  Month wise patient admissions
select monthname(date_of_admission) as month, month(date_of_admission) as month_num, count(*) as total_admission
from healthcare
group by month, month_num
order by month_num asc;


-- Hospital wise total patients with avg billing amount
select hospital, count(*) as total_patient,  ROUND(AVG(Billing_Amount), 2) AS avg_billing
from healthcare
group by hospital
order by total_patient desc;


-- Average length of stay by admission type
select admission_type, round(avg(length_of_stay),1) as avg_stay_days, COUNT(*) AS total_patients
from healthcare
group by admission_type
order by avg_stay_days desc;


-- Insurance provider wise revenue
select insurance_provider, round(sum(billing_amount),2) as total_revenue, round(avg(billing_amount),2) as avg_bills
from healthcare
group by insurance_provider
order by total_revenue desc;


-- Year over year patient growth
select year(date_of_admission) as year, count(*) as total_patient,
 ifnull(concat( round(
 (count(*)- lag(count(*)) over(order by year(date_of_admission)))/ lag(count(*)) over(order by year(date_of_admission)) * 100),
 "%"),
 "null") as yoy_growth
 from healthcare
 group by year
 order by year;


-- Patient Rank by Billing Amount in each medical condition
select name, medical_condition, billing_amount,
rank() over(partition by medical_condition order by billing_amount) as billing_rank
from healthcare;


-- Show highest billed patient per condition 
select h.name, h.medical_condition, h.billing_amount
from healthcare h
JOIN (
    SELECT medical_condition, MAX(billing_amount) AS max_bill
    FROM healthcare
    GROUP BY medical_condition
) m
ON h.medical_condition = m.medical_condition
AND h.billing_amount = m.max_bill;
                                       -- or
select * from (
     select name, medical_condition, billing_amount,
     Rank() over(partition by medical_condition order by billing_amount desc) as billing_rank
     from healthcare) ranks
where billing_rank=1;


-- Patients with Above Average Billing
select name, medical_condition, billing_amount
from healthcare
where billing_amount > ( select avg(Billing_Amount) from healthcare)
order by billing_amount desc
limit 20;









































































