-- ==============================================================================================================
-- ===== A. JINJA {% raw %} {{ ... }} {% endraw %} EXPRESSIONS =======================================================
-- ==============================================================================================================

-- 1. {% raw %} {{source('ecom','raw_customers')}} {% endraw %} gets converted to
{{ source('ecom','raw_customers') }}  

-- 2. {% raw %} {{ ref('customers') }} {% endraw %} gets converted to
{{ ref('customers') }}

-- 3. our custom macro in macro/convert_cents_to_dollars.sql
-- {% raw %} {{cents_to_dollars('argument')}} {% endraw %} gets converted to
{{cents_to_dollars('argument')}}



-- ==============================================================================================================
-- ===== B. JINJA {% raw %} {% ... %} {% endraw %} STATEMENTS =======================================================
-- ==============================================================================================================

-- 1. the {% raw %} {% for %} loop and {% if %} statements {% endraw %}
{% raw %}
-- {% for product_type in ['jaffle', 'beverage', 'coke'] %}
--     sum(case when type = '{{ product_type }}' then amount else 0)  as sum_product_{{ product_type }}
-- {% endfor %}
-- will compile to
{% endraw %}

{%- for product_type in ['jaffle', 'beverage', 'coke'] %}
    sum(case when type = '{{ product_type }}' then amount else 0)  as sum_product_{{ product_type }}
{%- endfor %}


-- 2.  a more dynamic version, getting "product_types" live from the source "raw_products"
{% raw %}
-- {% set product_types = run_query('select distinct type from ' ~ source('ecom','raw_products'))%}
-- {% if execute %} {% set product_list = product_types.columns[0].values() %} {% endif %}
-- {% for product in product_list  %}
--     sum(case when product = '{{ product }}' then amount else 0)  as sum_product_{{ product }}
-- {% endfor %}
{% endraw %}
-- gets compiled to

{%- set product_types = run_query('select distinct type from ' ~ source('ecom','raw_products'))%}

{%- if execute %} {% set product_list = product_types.columns[0].values() %} {% endif %}

{%- for product in product_list  %}
    sum(case when product = '{{ product }}' then amount else 0)  as sum_product_{{ product }}
{%- endfor %}