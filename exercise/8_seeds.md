### Exercise: Using dbt Seeds to Load Mapping Files

**Objective**: Use seed files to load a mapping file that enriches your store data with regional and managerial information. This exercise will help you understand how to use seeds in dbt to manage static data and enhance your data models with additional business context.

#### Context:

In your dbt project, seeds are used to load static data from CSV files into your database. This exercise will guide you through creating and using a seed file to enrich your store data with additional information about regions and managers.

#### Steps:

1. **Configure the Seed in dbt_project.yml**:
   - Add the seed configuration to your `dbt_project.yml` file to specify any necessary settings, such as column data types or tags.
```yaml
   seeds:
     jaffle_shop:
       store_region_mapping:
         +column_types:
           store_id: FILL_ME
           region: FILL_ME
           manager_name: FILL_ME
           manager_email: FILL_ME
```
2. **Run the Seed**:
   - Load the seed data into your database using the dbt command line interface.

   `dbt seed`

2. **Create a Model to Join Seed Data**:
   - Create a new dbt model that joins the `stg_location` data with the `store_region_mapping` seed to enrich the store data.
   - hint: you can use the `left join` clause to join the two tables. The code below drafts the outline for what to do : 
```sql
   -- models/staging/enriched_stores.sql

   with locations as (
    -- FILL ME WITH STG LOCATION DATA
   ),

   region_mapping as (
    -- FILL ME WITH SEED DATA
   )

   select
     -- FILL ME WITH COLUMNS FROM BOTH TABLES
   from locations
   left join region_mapping
   on locations.id = region_mapping.store_id
```

1. **Run the Model**:
   - Execute the model to create the enriched store data.

   `dbt run --select enriched_locations`

2. **Bonus : integrate the enriched logic directly into stg_locations**:
   - So far our approach is to join the mapping data in a new model, `enriched_location`. This is for user testing purposes so that they can verify the mapping is as expected.
   - Imagine after some time they signed off on the mapping data. Naturally we'd want to integrate this logic into the `stg_locations` model.
   - Modify the `stg_locations` model to directly join the seed data using a CTE.

#### Expected Outcome:

- You should have a seed file loaded into your database and a model that joins this seed data with your existing store data.
