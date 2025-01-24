with 
source as (
    select * from {{ref('snp_raw_customers_check_strat')}}
),

deleted_customers as (
select *
from source
where dbt_valid_to is not null
)

select * from deleted_customers