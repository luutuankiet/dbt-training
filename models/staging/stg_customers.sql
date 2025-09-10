with

source as (

    select * from {{ source('raw', 'raw_customers') }}

),

renamed as (

    select

        ----------  ids
        id as customer_id,

        ---------- text
        name as customer_name,
        'POS' as customer_source

    from source

)

select * from renamed
