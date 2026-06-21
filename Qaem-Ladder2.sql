-- # Summarizing Data with SQL
-- 
-- ## Summary Statistics
-- 32) How many rows are in the `pets` table?

-- select count(*)
-- from pets

-- 33) How many female pets are in the `pets` table?

-- select count(*)
-- from pets
-- where sex = 'F'

-- 34) How many female cats are in the `pets` table?

-- select count(*)
-- from pets
-- where sex = 'F' and species = 'cat'

-- 35) What's the mean age of pets in the `pets` table?

-- select round(avg(age),2)
-- from pets

-- 36) What's the mean age of dogs in the `pets` table?

-- select round(avg(age),2)
-- from pets
-- where species = 'dog'

-- 37) What's the mean age of male dogs in the `pets` table?

-- select round(avg(age),2)
-- from pets
-- where species = 'dog' and sex = 'M'

-- 38) What's the count, mean, minimum, and maximum of pet ages in the `pets` table?
--     * _NOTE:_ SQLite doesn't have built-in formulas for standard deviation or median!

-- select count(age),avg(age), min(age), max(age)
-- from pets

-- 39) Repeat the previous problem with the following stipulations:
--     * Round the average to one decimal place.
--     * Give each column a human-readable column name (for example, "Average Age")

-- select count(age) as total_age,round(avg(age),1) as average_age, min(age) as minimum_age, max(age) as maximum_age
-- from pets

-- 40) How many rows in `employees_null` have missing salaries?

-- select count(*)
-- from employees_null
-- where salary is null


-- 41) How many salespeople in `employees_null` having _nonmissing_ salaries?

-- select count(*)
-- from employees_null
-- where job = 'Sales' and salary is not null

-- 42) What's the mean salary of employees who joined the company after 2010? Go back to the usual `employees` table for this one.
--     * _Hint:_ You may need to use the `CAST()` function for this. To cast a string as a float, you can do `CAST(x AS REAL)`

-- select avg(salary) as average_salary_after_2010
-- from employees
-- where CAST(startdate as Real) > '2010'

-- 43) What's the mean salary of employees in Swiss Francs?
--     * _Hint:_ Swiss Francs are abbreviated "CHF" and 1 USD = 0.97 CHF.

-- select avg(salary)*0.97 as salary
-- from employees

-- 44) Create a query that computes the mean salary in USD as well as CHF. Give the columns human-readable names (for example "Mean Salary in USD"). Also, format them with comma delimiters and currency symbols.
--     * _NOTE:_ Comma-delimiting numbers is only available for integers in SQLite, so rounding (down) to the nearest dollar or franc will be done for us.
--     * _NOTE2:_ The symbols for francs is simply `Fr.` or `fr.`. So an example output will look like `100,000 Fr.`.

-- select '$ '|| format('%,d',salary) as Mean_Salary_in_USD,format('%,d',salary*0.97)|| ' Fr' as Mean_Salary_in_Fr
-- from employees


-- ## Aggregating Statistics with GROUP BY
-- 45) What is the average age of `pets` by species?

-- select species, avg(age) as average_age
-- from pets
-- group by species

-- 46) Repeat the previous problem but make sure the species label is also displayed! Assume this behavior is always being asked of you any time you use `GROUP BY`.

-- select species, avg(age) as average_age
-- from pets
-- group by species


-- 47) What is the count, mean, minimum, and maximum age by species in `pets`?

-- select species ,count(age) as total_age,round(avg(age),1) as mean_age, min(age) as minimum_age, max(age) as maximum_age
-- from pets
-- group by species

-- 48) Show the mean salaries of each job title in `employees`.

-- select job, avg(salary)
-- from employees
-- group by job

-- 49) Show the mean salaries in New Zealand dollars of each job title in `employees`.
--     * _NOTE:_ 1 USD = 1.65 NZD.

-- select job, avg(salary*1.65) as salary_in_NZD
-- from employees
-- group by job

-- 50) Show the mean, min, and max salaries of each job title in `employees`, as well as the numbers of employees in each category.

-- select count(*) as number_of_employees,job, avg(salary), min(salary), max(salary)
-- from employees
-- group by job

-- 51) Show the mean salaries of each job title in `employees` sorted descending by salary.

-- select job,avg(salary) as Average_salary
-- from employees
-- group by job
-- order by salary

-- 52) What are the top 5 most common first names among `employees`?

-- select firstname,count(firstname)
-- from employees
-- group by firstname
-- order  by count(*) DESC
-- limit 5

-- 53) Show all first names which have exactly 2 occurrences in `employees`.

-- select firstname, count(firstname)
-- from employees
-- group by firstname
-- having count(*) = 2

-- 54) Take a look at the `transactions` table to get a idea of what it contains. Note that a transaction may span multiple rows if different items are purchased as part of the same order. The employee who made the order is also given by their ID.
-- 55) Show the top 5 largest orders (and their respective customer) in terms of the numbers of items purchased in that order.

-- select customer, quantity
-- from transactions
-- order by quantity desc
-- limit 5


-- 56) Show the total cost of each transaction.
--     * _Hint:_ The `unit_price` column is the price of _one_ item. The customer may have purchased multiple.
--     * _Hint2:_ Note that transactions here span multiple rows if different items are purchased.
 
-- select order_id,sum(unit_price*quantity) as total_cost
-- from transactions
-- group by order_id

-- 57) Show the top 5 transactions in terms of total cost.

-- select order_id,sum(unit_price*quantity)as total_cost
-- from transactions
-- group by order_id
-- order by total_cost desc
-- limit 5

-- 58) Show the top 5 customers in terms of total revenue (ie, which customers have we done the most business with in terms of money?)

-- select customer,sum(unit_price*quantity) as total_revenue
-- from transactions
-- group by customer
-- order by total_revenue desc
-- limit 5


-- 59) Show the top 5 employees in terms of revenue generated (ie, which employees made the most in sales?)

-- select employee_id,sum(unit_price*quantity) as total_revenue
-- from transactions
-- group by employee_id
-- order by total_revenue desc
-- limit 5

-- 60) Which customer worked with the largest number of employees?
--     * _Hint:_ This is a tough one! Check out the `DISTINCT` keyword.

-- select customer , count(distinct employee_id) as number_of_employees
-- from transactions
-- group by customer
-- order by number_of_employees desc
-- limit 1

-- 61) Show all customers who've done more than $80,000 worth of business with us.

-- select customer, sum(unit_price*quantity) as total_business
-- from transactions
-- group by customer
-- having total_business > 80000

