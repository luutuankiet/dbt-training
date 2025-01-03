### Exercise : Singular, Generic Tests and Unit Tests

**Objective**: Develop custom generic tests to validate that a column in a model contains only positive values and create unit tests for specific models. Additionally, implement an `expression_is_true` test in `customers.yml`. This exercise will help you practice creating and applying custom tests and unit tests within your dbt project.

#### Context:

In your current dbt project, various data tests are defined, but there is a need to ensure specific conditions, such as positive values in columns and logical expressions, are met. This exercise will guide you in building these tests to enhance data quality and integrity.

#### Steps:

1. **Create a Singular Test**:

- Develop a singular test to ensure that the `order_total` in the `orders` model is always greater than or equal to the `subtotal`.
- Create a new SQL file for the singular test, e.g., `tests/order_total_greater_than_subtotal.sql`.
- Write a SQL query to identify any records where `order_total` is less than `subtotal`.
- Run the Singular Test:
  - Execute the singular test using the cloud IDE console : `dbt test --select order_total_greater_than_subtotal`

```sql
   -- tests/order_total_greater_than_subtotal.sql

   with invalid_orders as (
       select 
       -- FILL ME 
       -- hint : the columns you want to show in the test result
   
       from 
       --  FILL ME
       -- hint : use the ref function here to refer to the orders model.
   
       where order_total < subtotal
   )

   select count(*) as invalid_count
   from invalid_orders
```

2. **Create a generic test : Positive Value Test**:
   - We want to create a custom test that confirms our assumption that `supplies.supply_cost` should only contain positive values.
   - Create a new test file, e.g., `tests/positive_value.sql` with the content below.
   - Apply the Positive Value Test to `supplies.sql` model YAML configuration.

```sql
   {% test positive_value(column_name) %}
   
-- FILL LOGIC HERE
-- hint : use jinja variables {{ model }} and {{ column_name }} 
-- to refer to the column from the model that will use this test.

-- our test needs to return rows if there's negative value : 
-- select col from table where col <= 0 

   {% endtest %}
```

3. **Declare a pre imported generic test `expression_is_true` in `customers.yml`**:
   - Add a test to ensure that the sum of pre-tax spend and tax paid equals the total spend in model `marts/customer.sql`
   - **Hints**:
     - relevant columns are : `lifetime_spend_pretax`, `lifetime_tax_paid`, `lifetime_spend`
     - Use the `dbt_utils.expression_is_true` test [from the imported `dbt_utils` package](https://github.com/dbt-labs/dbt-utils?tab=readme-ov-file#expression_is_true-source).
     - Is a generic test that takes a SQL expression as an argument and returns true or false based on the expression's result.
     - i.e. dbt_utils.expression_is_true(column_name > 0) as an alternative to our previous custom test `positive_value`! Below is how you would use it in your model YAML configuration:

```yaml
# example for supplies.yml
# models/marts/supplies.yml
models:
  - name: supplies
  columns:
  - name: supply_cost
    data_tests:
      - dbt_utils.expression_is_true:
          expression: '> 0'



# example for customers.yml
# models/marts/customers.yml
models:
  - name: customers
    data_tests:
      # hint : declare the test to use here. 
      # Notice this test is decalared at THE MODEL LEVEL,
      # and not the column level.
      - FILL_ME_TEST_NAME:
          expression: "FILL ME"
          # hint : because we declared test at the model level,
          # we can pass in multiple columns from `customer` : lifetime_spend_pretax, lifetime_tax_paid, lifetime_spend. 

```

4. **Create Unit Tests for `stg_locations.yml`, `order_items.yml`,  `orders.yml` **:
   - Define unit tests to ensure that specific logic in your models is working as expected.
   - **Hints**:
     - Create a unit test configuration in the model's YAML file.
     - Use the `unit_tests` key to define the test.
     - Specify `given` and `expect` sections to outline input data and expected results.
     - Use the following structure as a guide, but fill in the critical parts:

4.1. **test_does_location_opened_at_trunc_to_date**

- **What**:

  - Checks that the `stg_locations` model correctly truncates the `opened_at` timestamp to a date.
  - In the provided code snippet, the `given` mock data has been provided. **Please fill in the FILL_ME in `expect` section.**

- **Why**:

  - This ensures that the `opened_at` field is properly converted to a date format, which is crucial for date-based analytics and reporting.

```yaml
# models/staging/stg_locations.yml

models:
  - name: stg_locations

# ---- snip ----

# note that unit_test block is on the same level as the model.
unit_tests:
  - name: test_does_location_opened_at_trunc_to_date
    description: "Check that opened_at timestamp is properly truncated to a date."
    model: stg_locations
    given:
      # note that the mock data can be arbitrary that don't need to exist in the models;
      # what we are testing is the LOGIC in the model.
      - input: source('ecom', 'raw_stores')
        rows:
          - { id: 1, name: "Vice City", tax_rate: 0.2, opened_at: "2016-09-01T00:00:00" } # Mock data for first store
          - { id: 2, name: "San Andreas", tax_rate: 0.1, opened_at: "2079-10-27T23:59:59.9999" } # Mock data for second store

    expect:
      rows:
        - { location_id: FILL_ME, location_name: FILL_ME, tax_rate: FILL_ME, opened_date: FILL_ME } # Expected result for first store
        - { location_id: FILL_ME, location_name: FILL_ME, tax_rate: FILL_ME, opened_date: FILL_ME } # Expected result for second store
```

- Consolidated info to help generate the above unit test:
| Model             | Column          | Source/Calculation                                   |
| ----------------- | --------------- | ---------------------------------------------------- |
| **stg_locations** | `location_id`   | Derived from `raw_stores.id`                         |
|                   | `location_name` | Derived from `raw_stores.name`                       |
|                   | `tax_rate`      | Directly from `raw_stores.tax_rate`                  |
|                   | `opened_date`   | Truncated from `raw_stores.opened_at` to date format |


4.2. **test_supply_costs_sum_correctly**

- **What**
  - verifies that the `order_items` model correctly calculates the total supply cost for each order.
  - logic : the model accurately **sums the supply costs** for all **products** associated with **each order**.
- **Why**: Accurate calculation of supply costs is crucial for financial reporting and inventory management.

```yaml
# models/marts/order_items.yml
models:
- name: order_items
# ---- snip ----

# note that unit_test block is on the same level as the model.
unit_tests:
- name: test_supply_costs_sum_correctly 
  description: "Test that supply costs sum correctly for each order."
  model: order_items
  given:
    # refer the upstream model that provides mock data
    # hint : use cloud IDE to inspect the lineage or view the code in `order_items.sql`
    # or refer to the consolidated tree view below.
    # note that the mock data can be arbitrary that don't need to exist in the models;
    # what we are testing is the LOGIC in the model.
    - input: ref('FILL_ME')  
      rows:
        - { product_id: FILL_ME, supply_cost: FILL_ME }  # Mock data for product 1
        - { product_id: FILL_ME, supply_cost: FILL_ME }  # Mock data for product 2, first entry
        - { product_id: FILL_ME, supply_cost: FILL_ME }  # Mock data for product 2, second entry
    - input: ref('FILL_ME')  # Reference the staging model for order items
      rows:
        - { order_id: FILL_ME, product_id: FILL_ME }  # Mock data for order 1
        - { order_id: FILL_ME, product_id: FILL_ME }  # Mock data for order 2, first entry
        - { order_id: FILL_ME, product_id: FILL_ME }  # Mock data for order 2, second entry

  expect:
    rows:
      - { order_id: FILL_ME, product_id: FILL_ME, supply_cost: FILL_ME }  # Expected result for order 1
      - { order_id: FILL_ME, product_id: FILL_ME, supply_cost: FILL_ME }  # Expected result for order 2

```

- Consolidated info to help generate the above unit test:

| Model               | Column        | Source/Calculation                                                                       |
| ------------------- | ------------- | ---------------------------------------------------------------------------------------- |
| **stg_supplies**    | `product_id`  | Directly from `stg_supplies`                                                             |
|                     | `supply_cost` | Directly from `stg_supplies`                                                             |
| **stg_order_items** | `order_id`    | Directly from `stg_order_items`                                                          |
|                     | `product_id`  | Directly from `stg_order_items`                                                          |
| **order_items**     | `order_id`    | Derived from `stg_order_items.order_id`                                                  |
|                     | `product_id`  | Derived from `stg_order_items.product_id` and `stg_supplies.product_id`                  |
|                     | `supply_cost` | Calculated as `sum(supply_cost)` from `stg_supplies.supply_cost` grouped by `product_id` |

4.3. **test_order_items_compute_to_bools_correctly**

- **What**:
  - Checks that the `orders` model correctly **count** the boolean value of upstream food and drink items.
- **Why**: This verify correct aggregation for downstream analytics and reporting, such as determining the types of orders placed by customers.

```yaml
# models/marts/orders.yml
models:
- name: orders
# ---- snip ----

# note that unit_test block is on the same level as the model.
unit_tests:
  - name: test_order_items_compute_to_bools_correctly
    description: "Test that the counts of drinks and food orders convert to booleans properly."
    model: orders
    given:
    # refer the upstream model that provides mock data
    # hint : use cloud IDE to inspect the lineage or view the code in `order_items.sql`
    # or refer to the consolidated tree view below.
    # note that the mock data can be arbitrary that don't need to exist in the models;
    # what we are testing is the LOGIC in the model.
      - input: ref('FILL_ME')  # Reference the model for order items
        rows:
          - { order_id: FILL_ME, order_item_id: FILL_ME, is_drink_item: FILL_ME, is_food_item: FILL_ME }  # Mock data for first order item
          - { order_id: FILL_ME, order_item_id: FILL_ME, is_drink_item: FILL_ME, is_food_item: FILL_ME }  # Mock data for second order item
          - { order_id: FILL_ME, order_item_id: FILL_ME, is_drink_item: FILL_ME, is_food_item: FILL_ME }  # Mock data for third order item

      - input: ref('FILL_ME')  # Reference the model for orders
        rows:
          - { order_id: FILL_ME }  # Mock data for first order
          - { order_id: FILL_ME }  # Mock data for second order

    expect:
      rows:
        - { order_id: FILL_ME, count_food_items: FILL_ME, count_drink_items: FILL_ME, is_drink_order: FILL_ME, is_food_order: FILL_ME }  # Expected result for first order
        - { order_id: FILL_ME, count_food_items: FILL_ME, count_drink_items: FILL_ME, is_drink_order: FILL_ME, is_food_order: FILL_ME }  # Expected result for second order


```

- Consolidated info to help generate the above unit test:

| Model           | Column              | Source/Calculation                                                 |
| --------------- | ------------------- | ------------------------------------------------------------------ |
| **order_items** | `order_id`          | Directly from `order_items`                                        |
|                 | `order_item_id`     | Directly from `order_items`                                        |
|                 | `is_drink_item`     | Directly from `order_items`                                        |
|                 | `is_food_item`      | Directly from `order_items`                                        |
| **stg_orders**  | `order_id`          | Directly from `stg_orders`                                         |
| **orders**      | `order_id`          | Derived from `stg_orders.order_id` and `order_items.order_id`      |
|                 | `count_food_items`  | Calculated as count of `order_items` where `is_food_item` is true  |
|                 | `count_drink_items` | Calculated as count of `order_items` where `is_drink_item` is true |
|                 | `is_food_order`     | Derived as true if `count_food_items` > 0                          |
|                 | `is_drink_order`    | Derived as true if `count_drink_items` > 0                         |


#### Expected Outcome:

- You should have the following tests in your project:
  - **singular test** for `order_total_greater_than_subtotal`
  - **generic test**
    - for positive values in `supplies.supply_cost`
    - `expression_is_true` test in `customers.yml`.
  - **unit tests** for `order_items.yml` , `orders.yml` and `stg_locations.yml`
- These tests will enhance your project's data quality assurance processes by ensuring data integrity and logical correctness.
