# Exercise: Using Common Table Expressions (CTEs)

## Objective

Learn how to use Common Table Expressions (CTEs) to organize and simplify complex SQL queries. This exercise will guide you through creating a model that uses multiple CTEs to transform and aggregate data.

## Instructions

1. **Create a New SQL File:**
   - In the `models/staging` directory, create a new SQL file named `stg_order_summary.sql`.
   - This file will contain the SQL logic to transform and summarize order data.

2. **Define the Source:**
   - Use the `source()` function to select data from the `raw_orders` and `raw_order_items` sources.
   - Create a CTE named `orders` to pull data from the `raw_orders` table.
   - Create another CTE named `order_items` to pull data from the `raw_items` table.

3. **Create a CTE for Data Transformation:**
   - Join the `orders` and `order_items` CTEs on `order_id`.
   - Calculate the total order value by summing the product of `quantity` and `price` for each item.
   - Group the results by `order_id`, `customer_id`, and `ordered_at`.

   ### Hints for Aggregations
   - **SUM()**: Calculate the total sum of a numeric column.
     - Example: Calculate the total sales amount.
       ```sql
       select sum(sales_amount) as total_sales
       from sales
       ```
   - **GROUP BY**: Use with aggregation functions to group results by one or more columns.
     - Example: Calculate total sales by customer.
       ```sql
       select customer_id, sum(sales_amount) as total_sales
       from sales
       group by customer_id
       ```

4. **Create Additional CTEs for Aggregation:**
   - Aggregate the data by `customer_id` to calculate the total number of orders and the total order value for each customer.
   - Use the `order_details` CTE as the source for this aggregation.

   ### More Hints for Aggregations
   - **COUNT()**: Count the number of rows or distinct values in a column.
     - Example: Count the number of orders.
       ```sql
       select count(order_id) as total_orders
       from orders
       ```
   - **HAVING**: Filter results after aggregation.
     - Example: Find customers with total sales greater than $1000.
       ```sql
       select customer_id, sum(sales_amount) as total_sales
       from sales
       group by customer_id
       having sum(sales_amount) > 1000
       ```

5. **Finalize the Query:**
   - Select the aggregated customer data from the final CTE to output the summarized results.

6. **Run and Test Your Model:**
   - Execute `dbt run` to build your model and verify the output in your database.
   - Ensure that the data is correctly aggregated and matches expected results.

