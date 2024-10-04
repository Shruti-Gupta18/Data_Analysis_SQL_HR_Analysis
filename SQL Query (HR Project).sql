use projects;
select * from hr;
describe hr;
select birthdate from hr;
set sql_safe_updates=0;
update hr
set birthdate = case
when birthdate like '%/%' then
date_format(str_to_date(birthdate,'%m/%d/%Y'),'%Y-%m-%d')
when birthdate like '%-%' then	
date_format(str_to_date(birthdate,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;
select * from hr;
describe hr;
alter table hr modify column birthdate date;
update hr
set hire_date = case
when hire_date like '%/%' then
date_format(str_to_date(hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%' then	
date_format(str_to_date(hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;
alter table hr modify column hire_date date;
alter table hr add column age int;
update hr
set age= timestampdiff(year,birthdate,curdate());
select min(age) as youngest, max(age) as oldest from hr;
select count(*) from hr where age>18;

/* 1. What is the gender breakdown of employee in the country? */
select gender, count(*) as count from hr
where age>=18 group by gender;

/*2. What is the race/ethnicity breakdown of employees in the company?*/
select race, count(*) as count
from hr
where age >=18
group by race
order by count desc;

/*3. What is the age distribution of employees in the company?*/
select min(age) as youngest, max(age) as oldest
from hr
where age>=18;

select floor(age/10)*10 as age_group, count(*) as count
from hr
where age>=18
group by floor(age/10)*10;

select
case
when age>=18 and age <=24 then '18-24'
when age>=25 and age <=34 then '25-34'
when age>=35 and age <=44 then '35-44'
when age>=45 and age <=54 then '45-54'
when age>=55 and age <=64 then '55-64'
else '65+'
end as age_group,
count(*) as count
from hr
where age >=18
group by age_group
order by age_group;

/*4. How many employees work at headquarters versus remote locations?*/
select location, count(*) as count
from hr
where age >=18 
group by location;

/*5. what is the average length of employement for employees who have been terminated?*/
select round(avg(datediff(termdate,hire_date))/365,0) as avg_length_of_employment
from hr
where termdate <> '0000-00-00' and termdate <= curdate() and age >=18;

/*6. How does the gender distribution vary across departmets and job titles?*/
select department, gender, count(*) as count
from hr
where age >=18
group by department, gender
order by department;

/*7. What is the distribution of job titles across the company?*/
select jobtitle, count(*) as count
from hr
where age >=18
group by jobtitle
order by jobtitle desc;

/*8. Which department has the highest turnover rate?
"Turnover rate" typically refers to the rate at which employees need to be replaced. It can be calculated as the number of employees given 
time period divided by the average number of employees who leave over a given time period divided by the average number of employees in the company or department
over the same time period*/
select department, count(*) as total_count,
sum(case when termdate <= curdate() and termdate <> '0000-00-00' then 1 else 0 end) as terminated_count,
sum(case when termdate = '0000-00-00' then 1 else 0 end) as active_count,
(sum(case when termdate <=curdate() then 1 else 0 end)/count(*)) as termination_rate
from hr
where age >=18
group by department
order by termination_rate desc;

/* 9. What is the distribution of employees across locations by city and state?*/
 select location_state, count(*) as count
 from hr
 where age >=18
 group by location_state
 order by count desc;
 
 /*10. How has the company's employee count changed over time based on hire and term dates?*/
SELECT YEAR(hire_date) AS year,
    COUNT(CASE WHEN hire_date IS NOT NULL THEN 1 END) AS hires,
    COUNT(CASE WHEN termdate IS NOT NULL AND YEAR(termdate) = YEAR(hire_date) THEN 1 END) AS terminations
FROM hr
GROUP BY YEAR(hire_date)
ORDER BY year;


/*11. What is the tenure distribution for each department?*/

select 
case
when age>=18 and age <=24 then '18-24'
when age>=25 and age <=34 then '25-34'
when age>=35 and age <=44 then '35-44'
when age>=45 and age <=54 then '45-54'
when age>=55 and age <=64 then '55-64'
else '65+'
end as age_group,
count(*) as count
from hr
where age >=18
group by age_group
order by age_group;




 














