# Staging Models Reference

- Here's how your models should look after completing the exercise:

## All Models Combined
```sql
-- stg_customers.sql
with

source as (

    select * from {{ source('ecom', 'raw_customers') }}

),

renamed as (

    select

        ----------  ids
        id as customer_id,

        ---------- text
        name as customer_name

    from source

)

select * from renamed

-- stg_locations.sql
with

source as (

    select * from {{ source('ecom', 'raw_stores') }}

),

renamed as (

    select

        ----------  ids
        id as location_id,

        ---------- text
        name as location_name,

        ---------- numerics
        tax_rate,

        ---------- timestamps
        timestamp_trunc(
        cast(opened_at as timestamp),
        day) as opened_date

    from source

)

select * from renamed

-- stg_order_items.sql
with

source as (

    select * from {{ source('ecom', 'raw_items') }}

),

renamed as (

    select

        ----------  ids
        id as order_item_id,
        order_id,
        sku as product_id

    from source

)

select * from renamed

-- stg_orders.sql
with

source as (

    select * from {{ source('ecom', 'raw_orders') }}

),

renamed as (

    select

        ----------  ids
        id as order_id,
        store_id as location_id,
        customer as customer_id,

        ---------- numerics
        subtotal as subtotal_cents,
        tax_paid as tax_paid_cents,
        order_total as order_total_cents,
    round(cast((subtotal / 100) as numeric), 2) as subtotal,
        
    round(cast((tax_paid / 100) as numeric), 2) as tax_paid,
        
    round(cast((order_total / 100) as numeric), 2) as order_total,

        ---------- timestamps
        timestamp_trunc(
        cast(ordered_at as timestamp),
        day
        ) as ordered_at

    from source

)

select * from renamed

-- stg_products.sql
with

source as (

    select * from {{ source('ecom', 'raw_products') }}

),

renamed as (

    select

        ----------  ids
        sku as product_id,

        ---------- text
        name as product_name,
        type as product_type,
        description as product_description,


        ---------- numerics
        
    round(cast((price / 100) as numeric), 2)
 as product_price,

        ---------- booleans
        coalesce(type = 'jaffle', false) as is_food_item,

        coalesce(type = 'beverage', false) as is_drink_item

    from source

)

select * from renamed

-- stg_supplies.sql
with

source as (

    select * from {{ source('ecom', 'raw_supplies') }}

),

renamed as (

    select

        ----------  ids
        to_hex(md5(cast(coalesce(cast(id as string), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(sku as string), '_dbt_utils_surrogate_key_null_') as string))) as supply_uuid,
        id as supply_id,
        sku as product_id,

        ---------- text
        name as supply_name,

        ---------- numerics
        
    round(cast((cost / 100) as numeric), 2)
 as supply_cost,

        ---------- booleans
        perishable as is_perishable_supply

    from source

)

select * from renamed
