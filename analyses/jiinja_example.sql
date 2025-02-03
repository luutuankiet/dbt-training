-- ==============================================================================================================
-- ===== A. JINJA {% raw %} {{ ... }} {% endraw %} EXPRESSIONS =======================================================
-- ==============================================================================================================

-- 1. {% raw %} {{ source('ecom','raw_customers') }} {% endraw %} gets converted to
{{ source('ecom','raw_customers') }}  

-- 2. {% raw %} {{ ref('customers') }} {% endraw %} gets converted to
{{ ref('customers') }}

-- 3. our custom macro in macro/convert_cents_to_dollars.sql
-- {% raw %} {{ cents_to_dollars('argument') }} {% endraw %} gets converted to
{{cents_to_dollars('argument')}}



-- ==============================================================================================================
-- ===== B. JINJA {% raw %} {% ... %} {% endraw %} STATEMENTS =======================================================
-- ==============================================================================================================

-- the {% raw %} {% for %} loop statements {% endraw %}
{% raw %}
-- {% for product_type in ['jaffle', 'beverage', 'coke'] %}
--     sum(case when type = '{{ product_type }}' then amount else 0)  as sum_product_{{ product_type }}
-- {% endfor %}
-- will compile to
{% endraw %}

{%- for product_type in ['jaffle', 'beverage', 'coke'] %}
    sum(case when type = '{{ product_type }}' then amount else 0)  as sum_product_{{ product_type }}
{%- endfor %}

