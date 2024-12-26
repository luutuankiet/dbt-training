## Reference Answer

Here is the reference SQL code for the exercise:

```sql
with orders as (
    select * from {{ source('ecom', 'raw_orders') }}
),
order_items as (
    select * from {{ source('ecom', 'raw_items') }}
),
order_details as (
    select
        o.order_id,
        o.customer_id,
        o.ordered_at,
        sum(i.quantity * i.price) as total_order_value
    from orders o
    join order_items i on o.order_id = i.order_id
    group by o.order_id, o.customer_id, o.ordered_at
),
customer_summary as (
    select
        customer_id,
        count(order_id) as total_orders,
        sum(total_order_value) as total_value
    from order_details
    group by customer_id
)

select * from customer_summary 
```