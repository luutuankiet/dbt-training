
## Reference Answer

Here is the reference SQL code for the exercise:

```sql
with stg_orders as (
    select
        order_id,
        customer_id,
        ordered_at,
        order_total_cents,
        tax_paid_cents,
        subtotal_cents
    from {{ ref('stg_orders') }}
),
stg_order_items as (
    select
        order_item_id,
        order_id,
        product_id
    from {{ ref('stg_order_items') }}
),
order_details as (
    select
        o.order_id,
        o.customer_id,
        o.ordered_at,
        sum(o.subtotal_cents) as total_subtotal_cents,
        sum(o.tax_paid_cents) as total_tax_paid_cents,
        sum(o.order_total_cents) as total_order_total_cents
    from stg_orders o
    join stg_order_items i on o.order_id = i.order_id
    group by o.order_id, o.customer_id, o.ordered_at
),
customer_summary as (
    select
        customer_id,
        count(order_id) as total_orders,
        sum(total_subtotal_cents) as total_subtotal_value_cents,
        sum(total_tax_paid_cents) as total_tax_value_cents,
        sum(total_order_total_cents) as total_order_value_cents
    from order_details
    group by customer_id
)

select * from customer_summary