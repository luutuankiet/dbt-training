   {% snapshot snp_raw_customers_check_strat %}

   {{
     config(
       target_schema='snapshots',
       unique_key='id',
       strategy='check',
       check_cols=['name', 'id']
     )
   }}

   select * from {{ ref('original_raw_customers') }}

   {% endsnapshot %}