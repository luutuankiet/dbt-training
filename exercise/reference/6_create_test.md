# 1. **singular test** for `order_total_greater_than_subtotal`
```sql

-- tests/order_total_greater_than_subtotal.sql
with invalid_orders as (
    select 
    -- the columns you want to show in the test result
    order_id, order_total, subtotal
    from {{ ref('orders') }}
    where order_total < subtotal
)

select count(*) as invalid_count
from invalid_orders

```

# 2. **generic test** for positive values in `supplies.supply_cost`

- the `positive_value` generic test should look like this :

```sql

   {% test positive_value(column_name) %}
   select *
   from {{ model }}
   where {{ column_name }} <= 0
   {% endtest %}
   
```

# 3. **generic test** for `customers.yml` using imported package `dbt_utils`

- expression test should look like this
```yaml
 #  models/marts/customers.yml
   models:
     - name: customers
       data_tests:
         - dbt_utils.expression_is_true:
             expression: "lifetime_spend_pretax + lifetime_tax_paid = lifetime_spend"
```

# 4. **unit tests** for `order_items.yml` and `orders.yml`

```yaml
 #  models/marts/order_items.yml
   unit_tests:
     - name: test_supply_costs_sum_correctly
       description: "Test that supply costs sum correctly for each order."
       model: order_items
       given:
         - input: ref('stg_supplies')
           rows:
             - { product_id: 1, supply_cost: 4.50 }
             - { product_id: 2, supply_cost: 3.50 }
             - { product_id: 2, supply_cost: 5.00 }
         - input: ref('stg_order_items')
           rows:
             - { order_id: 1, product_id: 1 }
             - { order_id: 2, product_id: 2 }
             - { order_id: 2, product_id: 2 }
       expect:
         rows:
           - { order_id: 1, product_id: 1, supply_cost: 4.50 }
           - { order_id: 2, product_id: 2, supply_cost: 8.50 }



 #  models/marts/orders.yml
   unit_tests:
     - name: test_order_items_compute_to_bools_correctly
       description: "Test that the counts of drinks and food orders convert to booleans properly."
       model: orders
       given:
         - input: ref('order_items')
           rows:
             - { order_id: 1, order_item_id: 1, is_drink_item: false, is_food_item: true }
             - { order_id: 1, order_item_id: 2, is_drink_item: true, is_food_item: false }
             - { order_id: 2, order_item_id: 3, is_drink_item: false, is_food_item: true }
         - input: ref('stg_orders')
           rows:
             - { order_id: 1 }
             - { order_id: 2 }
       expect:
         rows:
           - { order_id: 1, count_food_items: 1, count_drink_items: 1, is_drink_order: true, is_food_order: true }
           - { order_id: 2, count_food_items: 1, count_drink_items: 0, is_drink_order: false, is_food_order: true }
```
