select 
    {{ dbt_utils.star(from=ref('orders')) }}
from {{ ref('orders') }}