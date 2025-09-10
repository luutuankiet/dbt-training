with

    source as (
        select * from {{ source("raw", "raw_stores") }}
        ),

    region_mapping as (
        select * from {{ source("raw","store_region_mapping") }}
        ),

    enriched_locations as (
        select
            source.*,
            region_mapping.region,
            region_mapping.manager_name,
            region_mapping.manager_email
        from source
        left join region_mapping on source.id = region_mapping.store_id
    ),

    renamed as (

        select

            -- --------  ids
            id as location_id,

            -- -------- text
            name as location_name,
            region as location_region,
            manager_name as location_manager_name,
            manager_email as location_manager_email,

            -- -------- numerics
            tax_rate,

            -- -------- timestamps
            {{ dbt.date_trunc("day", "opened_at") }} as opened_date

        from enriched_locations

    ),

    final as (
        select * from renamed
        )

select *
from final