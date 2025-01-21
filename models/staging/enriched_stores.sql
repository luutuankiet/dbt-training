-- models/staging/enriched_stores.sql
with locations as (
    select *
    from {{ ref('stg_locations') }}
),
region_mapping as (
    select *
    from {{ ref('store_region_mapping') }}
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