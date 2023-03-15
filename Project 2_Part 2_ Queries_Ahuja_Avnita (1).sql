USE human_resources;

/*1. List all employees who work in the Engineering department within the Austin 
office. Report their employee ID, first name, last name, department, and office city.*/

SELECT 
	e.dept_id,
    e.first_name,
	e.last_name,
	e.office_id,
	d.dept_name,
	o.city
FROM employees e
LEFT JOIN departments d
	ON e.dept_id = d.dept_id
LEFT JOIN offices o
	ON o.office_id = e.office_id
WHERE d.dept_name = 'Engineering' AND o.city = 'Austin';
  
/*2. List all employees who have a role title of “Vice President”.  Report their 
employee ID, first name, last name, and role title.*/

SELECT 
	e.emp_id,
	e.first_name,
	e.last_name,
	r.role_title
FROM employees e
LEFT JOIN roles r
	ON e.role_id = r.role_id
WHERE e.role_id = '033';
  
/*3. List all female employees with the job title of “Director” in the Engineering 
department. Report their first name, last name, role title, department name, and 
office city.*/

SELECT 
	e.first_name,
	e.last_name,
	r.role_title,
	d.dept_name,
	o.city
FROM employees e
LEFT JOIN roles r
	ON e.role_id = r.role_id
LEFT JOIN departments d
	ON d.dept_id = e.dept_id
LEFT JOIN offices o
	ON o.office_id = e.office_id
WHERE e.role_id = '010' AND e.gender = 'F';

/*4. List all employees who work in either the Beijing or Miami offices and also 
work in the Accounting department. Report their first name, last name, office city, 
and department name.*/

SELECT 
	e.first_name,
	e.last_name,
	o.city,
	d.dept_name
FROM employees e
LEFT JOIN offices o
	ON o.office_id = e.office_id
LEFT JOIN departments d
	ON d.dept_id = e.dept_id
WHERE o.city IN ('Beijing' , 'Miami')
	AND (d.dept_name = 'Accounting');

/*5. Report all employees at the company who have the letter “c” as the third letter 
of their last name. Report their first name and last name.*/

SELECT 
	first_name,
	last_name
FROM employees
WHERE last_name LIKE '__c%';

/*6. Report all role titles that have a bonus of at least 10%. Report role title, salary 
range minimum, salary range maximum, and bonus percentage. (Note that you do 
not need to reformat any of these values.)*/

SELECT
	role_title,
    salary_range_min,
	salary_range_max,
    bonus_perc
FROM roles
WHERE bonus_perc <= '0.10';

/*7. List all employees who work in the Finance department in the Phoenix office, 
along with their monthly base salary. Report their first name, last name, 
department name, office city, annual base salary, and monthly base salary 
(“monthly_base_sal”).*/

SELECT 
	e.first_name,
	e.last_name,
	d.dept_name,
    o.city,
    e.annual_base_sal,
    annual_base_sal/12 AS monthly_base_sal
FROM employees e
LEFT JOIN departments d
	ON e.dept_id = d.dept_id
LEFT JOIN offices o
	ON o.office_id = e.office_id
WHERE d.dept_name = 'Finance' AND o.city = 'Phoenix';

/*8. Report the number of employees who work within each department. Provide 
the name of each department as well as the number of employees for each given 
department (“employee_count”). Departments should be ordered by highest 
number of employees to lowest number of employees.*/

SELECT
	d.dept_name,
	count(DISTINCT e.emp_id) AS employee_count
FROM employees e
INNER JOIN departments d
	ON e.dept_id = d.dept_id
GROUP BY dept_name
ORDER BY COUNT(DISTINCT e.emp_id);

/*9. List each department and their average base salaries. Order your results by 
highest to lowest average base salary. Report average base salary with a dollar sign 
($) and round to the nearest dollar.*/

SELECT
	d.dept_name,
	CONCAT('$', ROUND(AVG(e.annual_base_sal))) AS avg_base_salary
FROM employees e
INNER JOIN departments d
	ON e.dept_id = d.dept_id
GROUP BY dept_name
ORDER BY avg_base_salary DESC; 

/*10. List each employee who makes a base salary of $100,000 or more per year. 
Report their first name, last name, and annual base salary.*/ 

SELECT
	first_name,
    last_name,
    annual_base_sal
FROM employees
WHERE annual_base_sal > '100000';

/*11. List each role’s average annual base salary. Restrict your results to those roles 
that have an average base salary of $90,000 or higher. Report role title, average 
annual base salary (“avg_annual_base_sal”)*/

SELECT
	AVG(e.annual_base_sal),
	r.role_title
FROM employees	e
LEFT JOIN roles	r
	ON r.role_id = e.role_id
WHERE annual_base_sal < '900000'
GROUP BY role_title;

/*12. Create a list of each employee (emp_id, first_name, last_name) as well as a 
column called “bonus” that indicates whether that employee receives an 
annual bonus (with values of “Y” for yes and “N” for no).*/

SELECT
	e.emp_id,
    e.first_name,
    e.last_name,
    CASE WHEN bonus_perc IS null THEN 'N'
    ELSE 'Y'
	END AS Bonus
FROM employees e
INNER JOIN roles r
	ON r.role_id = e.role_id;

/*13. Create a copy of your “employees” table and call it “employees_2”. In this table, 
include all columns and records from “employees”, but add a column called “age”. 
Populate this column with each employee’s age (in years).*/

CREATE TABLE employees_2 AS 
SELECT * ;
SELECT *,
ROUND(DATEDIFF(current_date,dob)/365.25) AS age
FROM employees;

/*14. Create a table called “employee_salary”. In this table, include each employee’s 
employee ID, first name, last name, annual base salary, and bonus percentage.,. Also 
include the following additional columns: 
 “bonus_amt” (employee’s bonus amount in dollars)
  “total_annual_comp” (employee’s total annual compensation including base 
salary and bonus)*/

CREATE TABLE employees_salary AS SELECT * FROM employees;
SELECT
	e.emp_id,
    e.first_name,
    e.last_name,
    e.annual_base_sal,
    r.bonus_perc,
	CASE WHEN r.bonus_perc IS NULL THEN 0.00
		ELSE round(e.annual_base_sal * r.bonus_perc,2)
		END AS bonus_amt,
	CASE WHEN r.bonus_perc IS NULL THEN e.annual_base_sal
		ELSE round(e.annual_base_sal *(1+r.bonus_perc),2)
		END AS total_bonus_comp
FROM employees e
LEFT JOIN roles r ON r.role_id = e.role_id;

SELECT *
FROM employees_salary;

/*15. List all roles that have a salary range minimum that is less than $50,000. 
Report role_title, salary_range_min, and salary_range_max. Order your results by 
salary_range_min (lowest to highest).*/
 
SELECT 
	*
FROM roles
WHERE salary_range_min < 50000
ORDER BY salary_range_min;

/*16. List all roles that have a salary range maximum that is at least $50,000 greater 
than the salary range minimum. Report role_title, salary_range_min, and 
salary_range_max. Order your results by salary_range_max (highest to lowest).*/

SELECT
	role_title,
	salary_range_min,
	salary_range_max
FROM roles 
WHERE salary_range_max >= salary_range_min + 50000
ORDER BY salary_range_min DESC;

/*17.  List the salary ranges for each role title. List the role title, salary range minimum, 
salary range maximum, and salary range. Order your results by largest salary range 
to smallest salary range. Round all dollar amounts to the nearest dollar.*/

SELECT
	role_title,
    salary_range_min,
    salary_range_max,
    ROUND(salary_range_max - salary_range_min) AS salary_range
FROM roles
ORDER BY salary_range DESC;

/*18. Create a list of each employee who works in the Austin office (include first 
name and last name columns), along with their full office mailing address in 
the following format: First Name Last Name, Address 1, Address 2, City, State, 
Country Postal Code. (Example: John Smith, 14 Oak Drive, Suite 202, Rochester, New 
York, USA 10026)
(Note that some fields have commas between them, and some do not.)*/

SELECT 
    CONCAT(e.first_name,' ',e.last_name,', ', o.address_1,', ',o.address_2,', ',o.city,', ',o.state_province,', ',o.country,', ',o.postal_code) AS  employee_who_works_in_the_Austin_office
FROM employees e
INNER JOIN offices o
	ON o.office_id = e.office_id
WHERE o.city = 'Austin';

/*19. Pull a list of all employees with their respective role title and department in the 
following format: 
[FIRST INITIAL]. [ LAST NAME], [ROLE_TITLE], [DEPARTMENT]
E.g.: J. SMITH, VICE PRESIDENT, SALES
(Note all caps)*/

SELECT 
	UPPER(CONCAT(SUBSTR(e.first_name,1,1),".",
	e.last_name,", ",
	r.role_title,", ",
	d.dept_name))
from employees e
LEFT JOIN roles r 
	ON r.role_id = e.role_id
LEFT JOIN departments d
	ON d.dept_id = e.dept_id;

/*20. Create a table called “current_employees” that includes all data from the 
“employees” table but is restricted to employees who currently work at the 
company. (Hint: It is possible that all employees in the database currently work at the 
company.)*/

CREATE TABLE current_employees AS SELECT
*;
SELECT *
FROM employees
WHERE exit_date IS null;
SELECT * 
FROM current_employees;

/*21. BONUS (+5 POINTS): Report each office’s city along with the percentage of its 
employees who are female, male, and unspecified (perc_female, perc_male, 
perc_unspec). Exclude NULL values from your denominator. (HINT: you are allowed 
to write multiple queries/create multiple tables to achieve the required results.)*/

SELECT city, COUNT(*) FROM 
offices GROUP BY city;

DROP TABLE GenderWiseCount2;
CREATE TABLE GenderWiseCount2
AS
SELECT city,gender, COUNT(*) genderCt 
FROM employees e 
INNER JOIN offices o 
	ON e.office_id=o.office_id
GROUP BY gender,city
ORDER BY city;

DROP TABLE CityWiseEmployee;
CREATE TABLE CityWiseEmployee AS 
SELECT city,COUNT(*) noemployee 
FROM employees e 
INNER JOIN offices o 
	ON e.office_id=o.office_id
GROUP BY city
ORDER BY city;

SELECT gc.city,gender,(genderCt/noemployee )*100 
FROM GenderWiseCount2 gc 
INNER JOIN CityWiseEmployee ce ON gc.city=ce.city
ORDER BY gc.city,gender;

/*22. Next year, the company will be providing 3.5% raises to each employee’s base 
salary. Calculate each employee’s new base salary in a column called 
“base_salary_2023”. In your results, report each employee’s first name, last name, 
current base salary (as “base_salary_2022”) and “base_salary_2023”.*/

SELECT
	first_name,
    last_name,
    annual_base_sal * 1.035 AS base_salary_2023
FROM employees;

/*23. List all employees who have a first name that starts with the letter “J” and a 
last name that starts with the letter “R”. Include their emp_id, first_name, and 
last_name in your results.*/

SELECT
	emp_id,
    first_name,
    last_name
FROM employees
WHERE first_name LIKE 'J%' AND last_name LIKE 'R%';

/*24. Calculate the number of years that each employee has worked at the company 
(“employment_years”) as of the day that you conduct the query. Report the 
employee’s emp_id, first_name, last_name and employment_years.*/

SELECT
	emp_id,
    first_name,
    last_name,
    ROUND(((DATEDIFF(current_date,hire_date))/365.25),1) AS employement_years
FROM employees;

/*25. Report the number of employees within each combination of office and 
department. Report the office_city, dept_name, and employee_count.*/

SELECT
	o.city,
	d.dept_name,
	count(e.emp_id)
FROM offices o
LEFT JOIN employees e 
	ON e.office_id = o.office_id
LEFT JOIN departments d 
	ON d.dept_id = e.dept_id
GROUP BY o.city , d.dept_id;

    
/*26. Report all employees who were hired between 1/1/19 and 6/30/19. Report 
emp_id, first_name, last_name, and hire_date.*/

SELECT
	emp_id,
    first_name,
    last_name,
    hire_date
FROM employees
WHERE hire_date BETWEEN '2019-01-01' AND '2019-06-30';    

/*27. Report all employees who were hired in the month of January of any year. 
Report emp_id, first_name, last_name, and hire_date.*/  

SELECT
	emp_id,
    first_name,
    last_name,
    hire_date
FROM employees
WHERE MONTH(hire_date) = '01';

/*28. You have been asked to determine if the average annual base salary is greater 
for Computer Systems Managers or System Administrators. Calculate the 
average base salary for each role. Report the role_title and “avg_base_sal”.*/

SELECT
	r.role_title,
    AVG(e.annual_base_sal) AS avg_base_salary
FROM employees e
INNER JOIN roles r
	ON r.role_id = e.role_id
WHERE r.role_title IN ('Computer Systems Manager','System Administrator')
GROUP BY role_title;

/*29. Create a copy of the “offices” table and call it “offices_2”. In this table, include all 
columns and records from “offices”, but add an additional column called 
“continent”.  Populate this column with the continent that the given office is in.*/

CREATE TABLE office_2 AS SELECT *;

SELECT *,
	CASE WHEN country IN ('USA') THEN 'North America'
WHEN country IN ('China') THEN 'Asia'
	ELSE 'South America'
    END AS continent
FROM offices;
