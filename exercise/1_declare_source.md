# Exercise: Declare Data Sources

## Objective

Learn how to declare data sources in dbt by creating a `__sources.yml` file from scratch. This exercise will guide you through defining sources for your dbt project, which is essential for building models that reference raw data.

## Instructions

1. **Create the `__sources.yml` File:**

   - Head over to seaco's dbt project `raw-data-438007` in the console [here](https://console.cloud.google.com/bigquery?referrer=search&inv=1&invt=AblITg&project=raw-data-438007&ws=!1m4!1m3!3m2!1sraw-data-438007!2sdbt_training_Y24) and identify the dataset `dbt_training_Y24`.
     - This traininig dataset contains the source data for this exercise.
   - Navigate to the `models/staging` directory.
   - Create a new YAML file named `__sources.yml`. Include the following content:
     - hint: notice how this dataset is in a different project than the dbt project where our connection is set at `analytics-dev-438007`. In addition to declaring the dataset `dbt_training_Y24`, we need to explicitly specify the desired GCP project, `raw-data-438007` in the `database` field.

```yaml
sources:
  - name: ecom # the alias of this source in the dbt project i.e. {{source('ecom', 'orders')}}
    database: PLEASE_FILL_ME # the GCP project where the source tables are located
    schema: PLEASE_FILL_ME # the schema where the source tables are located
    description: "E-commerce data for the Jaffle Shop : a fictional online store that sells delicicous Jaffles."
```

2. **Define the Source:**

   - Start by declaring the source tables: append the following in the `__sources.yml` file:
     - hint: indentation matters here. `table` property should be nested under `source` (same indentation level as `source.name`).

```yaml
tables:
  - name: PLEASE_FILL_ME # the name of the source table
    description: PLEASE_FILL_ME # a brief description of the table
```

- Declare all the tables in the source, adding a new `- name` and `description` for each table.
  - Below are the descriptions for the table. Can you preview them in BQ console and guess which description belongs to which table?

```yaml
description: One record per person who has purchased one or more items
description: One record per order (consisting of one or more order items)
description: Items included in an order
description: One record per SKU for items sold in stores
description: One record per supply per SKU of items sold in stores  
```

3. **Set Freshness Criteria:**

   - Define freshness criteria to ensure the data is up-to-date; the hypothetical requirement for our training dataset is to warn if stale after 24hrs.
     - hint: refer to warn_after syntax [here](https://docs.getdbt.com/reference/resource-properties/freshness#complete-example).

4. **Test Your Source Declaration:**

   - Run `dbt source freshness` to test the freshness criteria and ensure your sources are correctly defined.
   - Verify that your sources are recognized by dbt and that the freshness checks pass.
   - If there are freshness warnings, can you adjust the freshness criteria to be 300 days? (because our training data are static.)


## Answer
- Check out the reference answer under `exercise/reference/1_declare_source.md`
