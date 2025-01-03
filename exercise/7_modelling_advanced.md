### Exercise 1 : Snapshot Strategy Implementation

**Objective**: Implement a snapshot strategy to track changes in a source table using both check and timestamp methods. This exercise will help you understand how to create and manage snapshots in dbt to capture historical data changes.

#### Context:

- In your dbt project, you may need to track changes in your source tables over time.
- We've prepared a sample source table `original_raw_customers.csv`, `simulate_raw_customers.csv` including record changes which you can use as a source for this exercise.

#### Steps:

1. **Load the simulated source data as seed** :
- Verify that there's a file `original_raw_customers.csv` `simulate_raw_customers.csv` in the `seeds` folder.
- Use the `dbt seed` command to load the seed data into your database, after which you can refer in your snapshot as `{{ref('simulate_raw_customers')}}`.

1. **Create a Snapshot Configuration**:
   - Define a new snapshot configuration file, e.g., `snapshots/snp_raw_customers.sql`.
   - Use the `snapshot` macro to define the snapshot logic.

```sql
   -- snapshots/snp_raw_customers_check_strat.sql

   {% snapshot snp_raw_customers_check_strat %}

   {{
     config(
       target_schema='snapshots',
       unique_key='id',
       strategy='check',
       check_cols=['name', 'id']
     )
   }}

   select * from {{ ref('original_raw_customers') }}

   {% endsnapshot %}
```

2. **Implement Timestamp Strategy**:
   - Modify the snapshot configuration to use a timestamp strategy.

```sql
   -- snapshots/snp_raw_customers_timestamp_strat.sql

   {% snapshot snp_raw_customers_timestamp_strat %}

   {{
     config(
       unique_key='id',
       strategy='timestamp',
       updated_at='last_updated'
     )
   }}

   select * from {{ ref('original_raw_customers') }}

   {% endsnapshot %}
```

3. **Run the Snapshot**:

   - Execute the snapshot using the dbt cloud IDE console :

   `dbt snapshot`

4. **Simulate Data Changes**:

   - Our ref model `simulate_raw_customers` includes some changes to the original data. 
   - To simulate the change, update the snapshot sql files's `ref` function to use the `simulate_raw_customers` model.
   - Re-run the snapshot to capture the changes : `dbt snapshot`

5. **Review Snapshot Results**:

   - Check the snapshot tables to ensure that changes are captured correctly : can you identify in which dataset did dbt build the snapshots ? 

#### Expected Outcome:

- You should have snapshots capturing changes in the `raw_customers` table using both check and timestamp strategies.

---

### Exercise 2 : Incremental Model Optimization

**Objective**: Convert an existing table model to an incremental model and optimize its performance. This exercise will help you understand how to implement incremental models in dbt to improve efficiency.

#### Context:

Incremental models in dbt allow you to process only new or updated records, improving performance and reducing resource usage. This exercise will guide you through converting a table model to an incremental model.

#### Steps:

1. **Identify a Table Model**:

   - Choose a table model that can benefit from incremental loading, such as `orders` - for the purpose of exercise, the scenario is that `orders` table was getting big causing performance hit to build your project.


2. **Modify the Model for Incremental Loading**:

   - Update the model to use the `incremental` materialization strategy.

```sql
   -- models/marts/orders.sql

   {{
     config(
       materialized='incremental',
       unique_key='order_id'
     )
   }}

   with new_orders as (
     select * from {{ ref('stg_orders') }}
     {% if is_incremental() %}
     where ordered_at > (select max(ordered_at) from {{ this }})
     {% endif %}
   )

   select * from new_orders
```

3. **Run the Incremental Model**:

   - Execute the model using the dbt command line interface.

   `dbt run --select orders`
   - Observe the compiled dbt code - can you spot the difference between incremental model and table model ?

5. **Optimize Further**:

   - Consider additional optimizations, such as indexing or partitioning, to further improve performance.
   - Further reading here : 
     - [dbt Incremental: Choosing the Right Strategy — P1](https://medium.com/refined-and-refactored/dbt-incremental-choosing-the-right-strategy-p1-6113d51898ec)
     - [dbt Incremental: Choosing the Right Strategy — P2](https://medium.com/refined-and-refactored/dbt-incremental-implementing-testing-p2-967e8a8e4240)
     - [dbt official docs](https://docs.getdbt.com/docs/build/incremental-models)

#### Expected Outcome:

- You should have an incremental model for the `orders` table that processes only new or updated records.
- This exercise will reinforce your understanding of incremental models in dbt and how they can be used to optimize performance.
