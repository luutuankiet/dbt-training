-- tests/order_total_greater_than_subtotal.sql
    select 
    -- the columns you want to show in the test result
    order_id, order_total, subtotal
    from {{ ref('orders') }}
    where order_total < subtotal