select 

orders.*,
order_items.*
    

from 
{{ ref('orders')}} 
left join {{ref('order_items')}}
on 1=1