create database Project;
use project;

-- to import data of csv file in "heathcare " table
CREATE TABLE healthcare (
    Name TEXT,
    Age INT,
    Gender TEXT,
    Blood_Type TEXT,
    Medical_Condition TEXT,
    Date_of_Admission DATE,
    Doctor TEXT,
    Hospital TEXT,
    Insurance_Provider TEXT,
    Billing_Amount DECIMAL(10,2),
    Room_Number INT,
    Admission_Type TEXT,
    Discharge_Date DATE,
    Medication TEXT,
    Test_Results TEXT,
    Length_of_Stay INT
);

SHOW VARIABLES LIKE 'secure_file_priv';        -- to check the safe path to load data 

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/healthcare dataset csv.csv'
INTO TABLE healthcare
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select count(*) from healthcare;
select* from healthcare;
----------------------------------------------------------------------------------------------------------------------------------

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
















