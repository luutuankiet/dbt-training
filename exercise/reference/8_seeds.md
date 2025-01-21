- Your enriched model should look like this:
```sql
-- models/staging/enriched_stores.sql
with locations as (
    select *
    from { { ref('stg_locations') } }
),
region_mapping as (
    select *
    from { { ref('store_region_mapping') } }
),
final as (
    select locations.*,
        region_mapping.region,
        region_mapping.manager_name,
        region_mapping.manager_email
    from locations
        left join region_mapping on locations.location_id = region_mapping.store_id
)
select *
from final
```


- Once integrated to `stg_location.sql` your model should now look like this:

```sql
-- models/staging/stg_locations.sql
with

    source as (
        select * from {{ source("ecom", "raw_stores") }}
        ),

    region_mapping as (
        select * from {{ ref("store_region_mapping") }}
        ),

    enrich_locations as (
        select
            source.*,
            region_mapping.region,
            region_mapping.manager_name,
            region_mapping.manager_email
        from source
        left join region_mapping on source.id = region_mapping.store_id
    )

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

```