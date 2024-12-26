# Test Overview for Staging Models

| Model                | Column Name       | Tests Applied          | Description                                      |
|----------------------|-------------------|------------------------|--------------------------------------------------|
| `stg_customers.sql`  | `customer_id`     | `not_null`, `unique`   | Unique identifier for each customer              |
|                      | `customer_name`   | `not_null`             | Name of the customer                             |
|                      |                   |                        |                                                  |
| `stg_locations.sql`  | `location_id`     | `not_null`, `unique`   | Unique identifier for each location              |
|                      | `location_name`   | `not_null`             | Name of the location                             |
|                      | `opened_date`     | `not_null`             | Date the location was opened                     |
|                      |                   |                        |                                                  |
| `stg_order_items.sql`| `order_item_id`   | `not_null`, `unique`   | Unique identifier for each order item            |
|                      | `product_id`      | `not_null`             | Identifier for the product                       |
|                      |                   |                        |                                                  |
| `stg_orders.sql`     | `order_id`        | `not_null`, `unique`   | Unique identifier for each order                 |
|                      | `location_id`     | `not_null`             | Identifier for the location                      |
|                      | `customer_id`     | `not_null`             | Identifier for the customer                      |
|                      | `ordered_at`      | `not_null`             | Date the order was placed                        |
|                      |                   |                        |                                                  |
| `stg_products.sql`   | `product_id`      | `not_null`, `unique`   | Unique identifier for each product               |
|                      | `product_name`    | `not_null`             | Name of the product                              |
|                      | `product_price`   | `not_null`             | Price of the product                             |
|                      |                   |                        |                                                  |
| `stg_supplies.sql`   | `supply_id`       | `not_null`, `unique`   | Unique identifier for each supply                |
|                      | `product_id`      | `not_null`             | Identifier for the product                       |
|                      | `supply_uuid`     | `not_null`, `unique`   | Unique identifier for each supply (UUID)         |
|                      | `supply_cost`     | `not_null`             | Cost of the supply                               |

