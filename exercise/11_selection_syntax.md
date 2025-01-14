# Exercise 2: Selection Syntax for Jobs

## Objective

Learn how to use dbt's selection syntax to target specific resources.

## Instructions

### 1. Basic Selection

- **Select a Specific Model:**
  - Run a dbt command to select a specific model by its name.
  - Use the command: 
    ```bash
    dbt run --select my_model_name
    ```
  - This command will execute only the specified model.

- **Select Models by Tag:**
  - Use the `--select` flag to run only models tagged with "nightly."
  - Use the command:
    ```bash
    dbt run --select tag:nightly
    ```
  - This will execute all models that have been tagged with "nightly."

### 2. Advanced Selection

- **Use State:Modified Selector:**
  - Run only modified models using the `state:modified` selector.
  - Use the command:
    ```bash
    dbt run --select state:modified
    ```
  - This will execute models that have been modified since the last state.

- **Graph Operators:**
  - Experiment with graph operators like `+` and `@` to include upstream and downstream models.
  - Use the command:
    ```bash
    dbt run --select my_model+
    ```
  - This will run the specified model and all its downstream dependencies.

  - Use the command:
    ```bash
    dbt run --select @my_model
    ```
  - This will run the specified model, its upstream dependencies, and all downstream models.

### Additional Exercises

#### Indirect Selection

- **Objective:** Understand how tests can be selected indirectly.
- **Tasks:**
  - Use the `--select` flag to run tests that depend on a specific model.
  - Use the command:
    ```bash
    dbt test --select my_model_name
    ```
  - This will run tests that are directly dependent on the specified model.

#### Exclude Resources

- **Objective:** Learn how to exclude specific resources from execution.
- **Tasks:**
  - Use the `--exclude` flag to exclude certain models or tags.
  - Use the command:
    ```bash
    dbt run --select tag:nightly --exclude my_model_name
    ```
  - This will run all models tagged with "nightly" except for the specified model.