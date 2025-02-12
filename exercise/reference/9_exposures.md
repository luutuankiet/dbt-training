- here's how your exposures should look like in your models yaml :
```yaml
exposures:
  - name: sales_dashboard
    type: dashboard
    depends_on:
      - ref('orders')
    description: "This exposure represents the sales dashboard, which relies on the orders model to provide insights into sales performance and trends."
    owner:
      email: "data.team@example.com"
      name: "Data Team"

  - name: customer_lifetime_value_analysis
    type: analysis
    depends_on:
      - ref('customers')
    description: "This exposure represents the analysis of customer lifetime value (LTV), which relies on the customers model to provide insights into customer spending patterns and retention."
    owner:
      email: "marketing.team@example.com"
      name: "Marketing Team"

  - name: inventory_management_dashboard
    type: dashboard
    depends_on:
      - ref('products')
    description: "This exposure represents the inventory management dashboard, which uses the products model to track stock levels, product performance, and reorder points."
    owner:
      email: "operations.team@example.com"
      name: "Operations Team"

  - name: supply_chain_efficiency_report
    type: report
    depends_on:
      - ref('supplies')
    description: "This exposure represents the supply chain efficiency report, which relies on the supplies model to analyze supply costs and identify opportunities for cost savings."
    owner:
      email: "supply.chain@example.com"
      name: "Supply Chain Team"

  - name: location_performance_metrics
    type: metrics
    depends_on:
      - ref('locations')
    description: "This exposure represents the location performance metrics, which use the locations model to evaluate the performance of different store locations based on sales and customer footfall."
    owner:
      email: "regional.managers@example.com"
      name: "Regional Managers"

  - name: order_fulfillment_efficiency_dashboard
    type: dashboard
    depends_on:
      - ref('order_items')
    description: "This exposure represents the order fulfillment efficiency dashboard, which uses the order_items model to monitor the efficiency of order processing and fulfillment times."
    owner:
      email: "logistics.team@example.com"
      name: "Logistics Team"
```