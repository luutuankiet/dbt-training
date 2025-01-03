### Exercise : Creating a Macro for Currency Conversion

Objective: Develop a macro that converts a specified column from cents to dollars. This exercise will help you practice creating reusable macros and applying them within your dbt models.

#### Context:

- Current Implementation: In the existing models, such as those in 2_create_staging_models.md, the conversion from cents to dollars is hardcoded using repetitive SQL expressions. This approach can lead to inconsistencies and maintenance challenges as the project evolves.
- Need for a Macro: By creating a cents_to_dollars macro, you can centralize the conversion logic, ensuring consistency across models and simplifying future updates or changes to the logic. This will replace the current hardcoded expressions, making the codebase more maintainable and scalable.

#### Steps:

1. **Define the Macro:**

- Create a new macro file, e.g., macros/cents_to_dollars.sql.
- Draft the code to encapsulate the conversion logic : `round(cast(( cents_field /100) asnumeric), 2)`
- Hint : the above logic is processed inside out in priority
  - cents_field / 100 > cast  as numeric > round the result by 2 decimals

```sql
-- macros/cents_to_dollars.sql
{%  macro  cents_to_dollars(column_name)  -%}
	-- FILL IN LOGIC HERE
	-- hint : to use variable `column_name` in this block, 
	-- you need to append it in jinja syntax : {{ column_name }}
   
{%-  endmacro  %}

```

2. **Apply the Macro in Models:**

- Replace the hardcoded conversion logic in these models with the new macro
  - stg_orders.sql
  - stg_products.sql
  - stg_supplies.sql
- hint : Example usage in `stg_orders.sql`

```sql

select

    ...

    {{  cents_to_dollars('subtotal')  }}  as  subtotal,

    {{  cents_to_dollars('tax_paid')  }}  as  tax_paid,

    {{  cents_to_dollars('order_total')  }}  as  order_total,

    ...

```

3. **Test the Macro:**

- Run `dbt run` to execute the models and ensure the currency conversion is applied correctly.
- Verify that the converted columns are calculated as expected in the output tables.

4. **Review and Optimize:**

- Consider adding additional logic to handle edge cases, such as negative values or nulls, if necessary.
- Test the macro with different columns and ensure it behaves consistently across various models.

#### Expected Outcome:

- You should have a consistent and reusable macro for converting cents to dollars across your dbt models.
