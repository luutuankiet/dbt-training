# Reference Answer: Declare Data Sources

Here is the reference YAML configuration for declaring data sources in dbt:

```yaml
sources:
  - name: ecom
    schema: dbt_training_Y24
    database: raw-data-438007
    description: E-commerce data for the Jaffle Shop
    freshness:
      warn_after:
        count: 24
        period: hour
    tables:
      - name: raw_customers
        description: One record per person who has purchased one or more items
      - name: raw_orders
        description: One record per order (consisting of one or more order items)
        loaded_at_field: ordered_at
      - name: raw_items
        description: Items included in an order
      - name: raw_stores
        loaded_at_field: opened_at
      - name: raw_products
        description: One record per SKU for items sold in stores
      - name: raw_supplies
        description: One record per supply per SKU of items sold in stores
```
