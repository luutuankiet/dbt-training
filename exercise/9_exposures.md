### Defining Exposures

**Objective**: Define an exposure for a critical model in your dbt project. This exercise will help you understand how to use exposures to document how and why data models are used, providing visibility into dependencies and the importance of specific models.

#### Context:

Exposures in dbt allow you to document the downstream use of your data models, such as reports, dashboards, or other analytical outputs. 
By defining exposures, you can better understand the impact of changes to your models and ensure that all stakeholders are aware of how data is being used.

#### Steps:

1. **Identify a Critical Model**:
   - Choose a mart model that is critical for business operations or analytics, such as the `orders` model, which is used for generating sales reports.
   - See the bottom of this exercise for a list of sample exposures to help you get started.

2. **Define an Exposure**:
   - Create an exposure in the upstream model's YAML file.
   - For instance, here's the exposure configuration for `models/marts/orders.yml`:

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
```
3. **Generate dbt Documentation**:
   - Generate the dbt documentation to visualize the exposure and its dependencies by running this in cloud IDE console:
```bash
   dbt docs generate
```
4. **Verify the Exposure**:
   - Check the generated documentation to ensure the exposure is correctly displayed and linked to the relevant models.

5. **Build the exposures**

 build your dbt project passing the exposures as arguments! 
```bash
dbt run -s +exposure:sales_dashboard
dbt test -s +exposure:sales_dashboard
```
- This approach would be useful once you have a bigger dbt project and might not want to rebuild the entire project just to debug / build a specific report.


#### Expected Outcome:

- You should have an exposure defined for a critical model, documenting its use in a business context.


## sample list of exposure ideas


| Exposure Name                          | Type      | Depends On    | Description                                                                                                                                                                             | Owner Name        | Owner Email                   |
| -------------------------------------- | --------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------- | ----------------------------- |
| sales dashboard                        | Dashboard | `orders`      | This exposure represents the sales dashboard, which relies on the orders model to provide insights into sales performance and trends.                                                   | Data Team         | data.team@example.com         |
| inventory management dashboard         | Dashboard | `products`    | This exposure represents the inventory management dashboard, which uses the products model to track stock levels, product performance, and reorder points.                              | Operations Team   | operations.team@example.com   |
| order fulfillment efficiency dashboard | Dashboard | `order_items` | This exposure represents the order fulfillment efficiency dashboard, which uses the order_items model to monitor the efficiency of order processing and fulfillment times.              | Logistics Team    | logistics.team@example.com    |
| customer lifetime value analysis       | Analysis  | `customers`   | This exposure represents the analysis of customer lifetime value (LTV), which relies on the customers model to provide insights into customer spending patterns and retention.          | Marketing Team    | marketing.team@example.com    |
| supply chain efficiency report         | Report    | `supplies`    | This exposure represents the supply chain efficiency report, which relies on the supplies model to analyze supply costs and identify opportunities for cost savings.                    | Supply Chain Team | supply.chain@example.com      |
| location performance metrics           | Metrics   | `locations`   | This exposure represents the location performance metrics, which use the locations model to evaluate the performance of different store locations based on sales and customer footfall. | Regional Managers | regional.managers@example.com |
