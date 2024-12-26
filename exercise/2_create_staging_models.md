# Exercise: Create Staging Models

## Objective

Learn how to create staging models that transform raw data into clean, usable datasets. This exercise will guide you through implementing consistent naming conventions and basic transformations.

## Instructions

1. **Create Staging Models skeleton:**

   - Navigate to the `models/staging` directory
   - Start with creating `stg_customers.sql` with the following structure:

     ```sql
     -- Start with this structure:
     with source as (
         select * from {{ source('ecom', 'raw_customers') }}
     ),
     renamed as (
         select


         from source
     )

     select * from renamed

     ```
2. **Order columns by data type:**

   - Identify & group the source fields by data type. Identify your source tables schema using bigquery console and write all the column down under the `renamed as (    )` block.
   - Tip: scroll down to the "Schema overview" section for the schema of our source tables. For example if the table `raw customer` has the following columns :

| Column Name | Data Type | Example Values           |
| ----------- | --------- | ------------------------ |
| id          | STRING    | 'C001', 'C002'           |
| name        | STRING    | 'John Smith', 'Jane Doe' |

- Then you can write the following code. As best practice, **all columns of the source table** should be explicitly mentioned in the `renamed as (    )` block.

  ```sql
  with source as (
      select * from {{ source('ecom', 'raw_customers') }}
  ),
  renamed as (
  select

  -------- ids
  -- Put all id fields here
   id,

  -------- text
  -- Put all text fields here
   name
  -------- numerics
  -- Convert cents to dollars: amount / 100.0

  -------- timestamps
  -- Convert to date


  -------- booleans
  -- Create flags: CASE WHEN column = 'value' THEN true ELSE false END

  from source

  select * from renamed
  )
  ```

3. **Apply renaming & simple SQL Transformations:**

   - Rename the models column to be more descriptive, and apply simple SQL transformations.
   - Identify the section "Transformation Logic Overview" at the bottom of this page for instructions which column to rename and transformation to apply to each column; make the appropriate changes to the `renamed as (    )` block.
4. **Verify Your Work:**

   - After completing the steps about for each model, hit the `build` / `preview` button to verify your code.

# Schema Overview: Jaffle Shop Raw Data

## Raw Customers

| Column Name | Data Type | Example Values           |
| ----------- | --------- | ------------------------ |
| id          | STRING    | 'C001', 'C002'           |
| name        | STRING    | 'John Smith', 'Jane Doe' |

## Raw Items

| Column Name | Data Type | Example Values |
| ----------- | --------- | -------------- |
| id          | STRING    | 'I001', 'I002' |
| order_id    | STRING    | 'O001', 'O001' |
| sku         | STRING    | 'P001', 'P002' |
| quantity    | INTEGER   | 2, 1           |

## Raw Orders

| Column Name | Data Type | Example Values                               |
| ----------- | --------- | -------------------------------------------- |
| id          | STRING    | 'O001', 'O002'                               |
| customer    | STRING    | 'C001', 'C002'                               |
| store_id    | STRING    | 'S001', 'S001'                               |
| ordered_at  | TIMESTAMP | '2023-01-01 10:00:00', '2023-01-01 11:00:00' |
| subtotal    | INTEGER   | 1000, 500                                    |
| tax_paid    | INTEGER   | 100, 50                                      |
| order_total | INTEGER   | 1100, 550                                    |

## Raw Products

| Column Name | Data Type | Example Values                    |
| ----------- | --------- | --------------------------------- |
| sku         | STRING    | 'P001', 'P002'                    |
| name        | STRING    | 'Classic Jaffle', 'Cheese Jaffle' |
| type        | STRING    | 'jaffle', 'jaffle'                |
| price       | INTEGER   | 800, 900                          |
| description | STRING    | 'Original recipe', 'Extra cheesy' |

## Raw Stores

| Column Name | Data Type | Example Values                               |
| ----------- | --------- | -------------------------------------------- |
| id          | STRING    | 'S001', 'S002'                               |
| name        | STRING    | 'Downtown Store', 'Uptown Store'             |
| opened_at   | TIMESTAMP | '2023-01-01 09:00:00', '2023-01-02 09:00:00' |
| tax_rate    | FLOAT     | 0.10, 0.08                                   |

## Raw Supplies

| Column Name | Data Type | Example Values    |
| ----------- | --------- | ----------------- |
| id          | STRING    | 'SP001', 'SP002'  |
| name        | STRING    | 'Bread', 'Cheese' |
| cost        | INTEGER   | 200, 300          |
| perishable  | BOOLEAN   | true, true        |
| sku         | STRING    | 'P001', 'P001'    |

# Transformation Logic Overview

| Model | Source Table | Key Transformations |
| ----------------------- | ----------------- | ---------------------------------------------------------------------------------------- |
| `stg_customers.sql` | `raw_customers` | - Rename `id` to `customer_id` |
| | | - Rename `name` to `customer_name` |
| | | |
| `stg_locations.sql` | `raw_stores` | - Rename `id` to `location_id` |
| | | - Rename `name` to `location_name` |
| | | - Convert `opened_at` to `opened_date` using timestamp_trunc(cast(opened_at as timestamp), day) |
| | | |
| `stg_order_items.sql` | `raw_items` | - Rename `id` to `order_item_id` |
| | | - Rename `sku` to `product_id` |
| | | |
| `stg_orders.sql` | `raw_orders` | - Rename `id` to `order_id` |
| | | - Rename `store_id` to `location_id` |
| | | - Rename `customer` to `customer_id` |
| | | - Convert monetary columns using round(cast((amount / 100) as numeric), 2) |
| | | - Convert `ordered_at` using timestamp_trunc(cast(ordered_at as timestamp), day) |
| | | |
| `stg_products.sql` | `raw_products` | - Rename `sku` to `product_id` |
| | | - Rename `name` to `product_name` |
| | | - Convert `price` using round(cast((price / 100) as numeric), 2) |
| | | - Create boolean columns using COALESCE(type = 'jaffle', false) as is_food_item |
| | | |
| `stg_supplies.sql` | `raw_supplies` | - Generate `supply_uuid` using to_hex(md5(cast(coalesce(cast(id as string), '_null_') || '-' || coalesce(cast(sku as string), '_null_') as string))) |
| | | - Rename `id` to `supply_id` |
| | | - Rename `sku` to `product_id` |
| | | - Convert `cost` using round(cast((cost / 100) as numeric), 2) |
| | | - Rename `perishable` to `is_perishable_supply` |
