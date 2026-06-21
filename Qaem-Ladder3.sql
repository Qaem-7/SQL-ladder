-- # Joins
-- 
-- This file contains several exercises on joins. These topics are a step more involved and confusing than in the previous two files.
-- * [Tutorial on Joins](https://www.sqlitetutorial.net/sqlite-join/)
-- 
-- Here are a few other important notes I'd like you read before beginning:
-- * Make sure you read each question thoroughly.
-- * Don't skip problems, as some problems may rely on previous problems being done correctly.
-- * Make sure you are saving your answers as you go, as some answers will simply be reworkings of previous answers.
-- * A View is a virtual table that represents the result of a stored SELECT query. Unlike a physical table, it does not store data, but it can be queried like a table.
-- 
-- ## Joins
-- 
-- 62) Which employee made which sale? Join the `employees` table onto the `transactions` table by `employee_id`. You only need to include the employee's first/last name from `employees`.

-- select firstname, lastname , order_id
-- from employees e
-- 	join transactions t
-- 		on e.ID = t.employee_id

-- 63) What is the name of the employee who made the most in sales? Find this answer by doing a join as in the previous problem. Your resulting query will be difficult for someone else to read.

-- select firstname , lastname,sum(t.unit_price * t.quantity) as total_sales_usd
-- from employees e
-- 	join transactions t
-- 		on e.ID = t.employee_id
-- group by e.ID, e.firstname, e.lastname
-- order by total_sales_usd
-- limit 1

-- 64) Solve the previous problem by joining `employees` onto the `trans_by_employee` view.

-- select firstname, lastname, total_cost
-- from employees e
-- 	join trans_by_employee tbe
-- 		on e.ID = tbe.employee_id
-- order by total_cost desc
-- limit 1;

-- 65) Next, the company will try to give bonuses based on performance. Show all employees who've made more in sales than 1.5 times their salary.

-- select firstname, lastname, salary, total_cost as total_sales
-- from employees e
-- 	join trans_by_employee tbe
-- 		on e.ID = tbe.employee_id
-- where total_cost > (salary * 1.5)

-- 66) Do we have potentially erroneous rows? Find all transactions which occurred _before_ the employee was even hired! (Make sure each transaction only occupies one row).

-- select t.order_id, t.customer, e.firstname || ' ' || e.lastname AS employee_name,  t.orderdate ,e.startdate AS hire_date
-- from transactions t
-- 	join employees e 
-- 		on t.employee_id = e.ID
-- where t.orderdate < e.startdate

-- 67) Among all transactions that occurred from 2015 to 2019, create a table that is the monthly revenue of our company versus the total trading volume of Yum! in that month. Format the columns nicely. (Hint: look at the views) That is, a sample row of your result might look like this:
-- 
-- ```
-- | year | month | company_revenue | yum_trade_volume |
-- |------|-------|-----------------|------------------|
-- | 2017 |    03 |        $100,000 |      125,000,000 |
-- ```
-- 
-- * _Hint:_ You don't need any `WHERE` statements here. You can get the right answer simply by changing what kind of join you do!

-- select strftime('%Y', t.orderdate) as year,
-- 	   strftime('%m', t.orderdate) as month, 
-- 	   '$' || format('%,d', CAST(sum(t.unit_price * t.quantity) as integer)) as company_revenue, 
-- 	   FORMAT('%,d', y.volume) as yum_trade_volume
-- from transactions t
-- 	join yum y 
-- 		on strftime('%Y-%m', t.orderdate) = strftime('%Y-%m', y.date)
-- group by year, month
-- order by year, month	