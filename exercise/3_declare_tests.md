# Exercise: Declare Tests for Staging Models

## Objective

Learn how to declare tests for your dbt models by creating YAML files. This exercise will guide you through defining schema tests to ensure data quality and integrity for models in the `staging` directory.

## Instructions

1. **Create a YAML File for Tests:**
   - For each model in the `models/staging` directory, create a corresponding YAML file to define tests.
   - Name the YAML file to match the model it tests, e.g., `stg_customers.yml` for `stg_customers.sql`.

2. **Define the Model in the YAML File:**
   - Begin by defining the model name and description in the YAML file.
   - For example for `stg_customers.sql`:
     ```yaml
     version: 2

     models:
       - name: stg_customers
         description: Staging model for customer data
     ```

3. **Add Tests for the Model:**
   - Define tests for key columns to ensure data quality. Common tests include checking for non-null values and uniqueness.
   - For Example for `stg_customers.sql`:
     ```yaml
         columns:
           - name: customer_id
             description: Unique identifier for each customer
             tests:
               - not_null
               - unique

           - name: customer_name
             description: Name of the customer
             tests:
               - not_null
     ```

4. **Repeat for Other Models:**
   - Repeat the process for other models in the `staging` directory, such as `stg_locations.sql`, `stg_order_items.sql`, etc.
   - Ensure each model has a corresponding YAML file with appropriate tests defined.

5. **Verify Your Test Configuration:**
   - Ensure your YAML files are correctly formatted and all necessary fields are included.
   - Use a YAML validator if needed to check for syntax errors.

6. **Run Your Tests:**
   - Execute `dbt test` to run the tests you have defined.
   - Review the output to ensure all tests pass and address any issues that arise.

## Additional Tips

- **Use Descriptive Names and Descriptions:** Ensure that your model and column names, as well as descriptions, are clear and informative.
- **Documentation:** Add comments in your YAML files to explain each test, which will help you and others understand the purpose of each test.
- **Consistency:** Maintain consistency in how you define tests across your models to ensure clarity and ease of maintenance.

