{{ config(severity='warn') }}

-- asumption : all upstream product prices was raised above 10$
select name,
        type,
        {{cents_to_dollar('price')}}
from {{ source('ecom','raw_products') }} 
where {{cents_to_dollars('price')}} < 10