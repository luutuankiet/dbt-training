# Prerequisites for Advanced Modelling training session

- Before joining the session, please ensure you have completed the following tasks to create `marts` models. 
- We will have some exercises that are based on these models.
- Create the following models under `models/marts` directory:

- **customers.sql**

  - Create CTE for `customers`:
    ```sql
    WITH customers AS (
        SELECT * FROM {{ ref('stg_customers') }}  -- Select all columns from the staging customers table
    )
    ```
  - Create CTE for `orders`:
    ```sql
    ,orders AS (
        SELECT * FROM {{ ref('orders') }}  -- Select all columns from the orders table
    )
    ```
  - Join `customers` with `orders` and calculate metrics:
    ```sql
    ,joined as (
    	SELECT
        customers.*,  -- Select all columns from customers
        COUNT(DISTINCT orders.order_id) AS count_lifetime_orders,  -- Count unique orders for each customer
        MIN(orders.ordered_at) AS first_ordered_at,  -- Find the earliest order date for each customer
        MAX(orders.ordered_at) AS last_ordered_at,  -- Find the latest order date for each customer
        SUM(orders.subtotal) AS lifetime_spend_pretax,  -- Sum of all order subtotals for each customer
        SUM(orders.tax_paid) AS lifetime_tax_paid,  -- Sum of all taxes paid for each customer
        SUM(orders.order_total) AS lifetime_spend,  -- Sum of total spend for each customer
        CASE
            WHEN COUNT(DISTINCT orders.order_id) > 1 THEN 'returning'  -- If more than one order, mark as returning
            ELSE 'new'  -- Otherwise, mark as new
        END AS customer_type
    FROM customers
    LEFT JOIN orders ON customers.customer_id = orders.customer_id  -- Join customers with orders on customer_id
    GROUP BY customers.customer_id  -- Group by customer_id to aggregate data
    )

    ```
  - finally select all columns from `joined`
  
  ```sql
  SELECT * FROM joined  -- Retrieve all columns from the joined CTE
  ```
- **locations.sql**

  - Create CTE for `locations`:
    ```sql
    WITH locations AS (
        SELECT * FROM {{ ref('stg_locations') }}  -- Select all columns from the staging locations table
    )
    ```
  - Select all columns from `locations`:
    ```sql
    SELECT * FROM locations  -- Retrieve all columns from the locations CTE
    ```
- **order_items.sql**

  - Create CTE for `order_items`:
    ```sql
    WITH order_items AS (
        SELECT * FROM {{ ref('stg_order_items') }}  -- Select all columns from the staging order items table
    )
    ```
  - Create CTE for `orders`:
    ```sql
    ,orders AS (
        SELECT * FROM {{ ref('stg_orders') }}  -- Select all columns from the staging orders table
    )
    ```
  - Create CTE for `products`:
    ```sql
    ,products AS (
        SELECT * FROM {{ ref('stg_products') }}  -- Select all columns from the staging products table
    )
    ```
  - Create CTE for `supplies`:
    ```sql
    ,supplies AS (
        SELECT * FROM {{ ref('stg_supplies') }}  -- Select all columns from the staging supplies table
    )
    ```
  - Join CTEs and calculate `supply_cost`:
    ```sql
    ,joined AS (
    SELECT
        order_items.*,  -- Select all columns from order_items
        orders.ordered_at,  -- Include order date from orders
        products.product_name,  -- Include product name from products
        products.product_price,  -- Include product price from products
        products.is_food_item,  -- Include food item flag from products
        products.is_drink_item,  -- Include drink item flag from products
        SUM(supplies.supply_cost) AS supply_cost  -- Sum supply costs for each product
    FROM order_items
    LEFT JOIN orders ON order_items.order_id = orders.order_id  -- Join order_items with orders on order_id
    LEFT JOIN products ON order_items.product_id = products.product_id  -- Join order_items with products on product_id
    LEFT JOIN supplies ON order_items.product_id = supplies.product_id  -- Join order_items with supplies on product_id
    GROUP BY order_items.order_item_id  -- Group by order_item_id to aggregate data
    )
    ```
    - Select all columns from `joined`:
```sql
SELECT * FROM joined  -- Retrieve all columns from the joined CTE
```

- **orders.sql**

  - Create CTE for `orders`:
    ```sql
    WITH orders AS (
        SELECT * FROM {{ ref('stg_orders') }}  -- Select all columns from the staging orders table
    )
    ```
  - Create CTE for `order_items`:
    ```sql
    ,order_items AS (
        SELECT * FROM {{ ref('order_items') }}  -- Select all columns from the order items table
    )
    ```
  - Join CTEs and calculate order metrics:
    ```sql
    ,joined AS (
    SELECT
        orders.*,  -- Select all columns from orders
        SUM(order_items.product_price * order_items.quantity) AS order_cost,  -- Calculate total cost of order
        COUNT(order_items.order_item_id) AS count_order_items,  -- Count number of items in each order
        COUNT(CASE WHEN order_items.is_food_item THEN 1 END) AS count_food_items,  -- Count food items in each order
        COUNT(CASE WHEN order_items.is_drink_item THEN 1 END) AS count_drink_items,  -- Count drink items in each order
        CASE WHEN COUNT(CASE WHEN order_items.is_food_item THEN 1 END) > 0 THEN TRUE ELSE FALSE END AS is_food_order,  -- Flag if order contains food
        CASE WHEN COUNT(CASE WHEN order_items.is_drink_item THEN 1 END) > 0 THEN TRUE ELSE FALSE END AS is_drink_order,  -- Flag if order contains drinks
        ROW_NUMBER() OVER (PARTITION BY orders.customer_id ORDER BY orders.ordered_at) AS customer_order_number  -- Assign order number per customer
    FROM orders
    LEFT JOIN order_items ON orders.order_id = order_items.order_id  -- Join orders with order_items on order_id
    GROUP BY orders.order_id  -- Group by order_id to aggregate data
    )
    ```
     - Select all columns from `joined`:
    ```sql
    SELECT * FROM joined  -- Retrieve all columns from the joined CTE
    ```

- **products.sql**

  - Create CTE for `products`:
    ```sql
    WITH products AS (
        SELECT * FROM {{ ref('stg_products') }}  -- Select all columns from the staging products table
    )
    ```
  - Select all columns from `products`:
    ```sql
    SELECT * FROM products  -- Retrieve all columns from the products CTE
    ```
- **supplies.sql**

  - Create CTE for `supplies`:
    ```sql
    WITH supplies AS (
        SELECT * FROM {{ ref('stg_supplies') }}  -- Select all columns from the staging supplies table
    )
    ```
  - Select all columns from `supplies`:
    ```sql
    SELECT * FROM supplies  -- Retrieve all columns from the supplies CTE
    ```
