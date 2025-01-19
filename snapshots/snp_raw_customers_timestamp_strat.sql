 {% snapshot snp_raw_customers_timestamp_strat %}

   {{
     config(
       unique_key='id',
       strategy='timestamp',
       updated_at='last_updated'
     )
   }}

   select * from {{ ref('original_raw_customers') }}

   {% endsnapshot %}