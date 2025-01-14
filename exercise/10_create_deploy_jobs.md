# Exercise 1: Setting Up Jobs in dbt Cloud

## Objective

Understand how to set up and configure different types of jobs in dbt Cloud.

## Instructions

### 1. Create a Deploy Job

- **Navigate to the Jobs Page:**
  - Go to your dbt Cloud account and navigate to the "Deploy" section.
  - Click on "Jobs" to view existing jobs or create a new one.

- **Set Up a Deploy Job:**
  - Click "Create Job" and select "Deploy Job."
  - Name the job, e.g., "Daily Build Job."
  - In the "Execution Settings," add the command `dbt build`.
  - Enable the "Generate docs on run" option to generate project documentation.

- **Schedule the Job:**
  - In the "Triggers" section, set the job to run daily at a specific time using the cron schedule option.

### 2. Configure Source Freshness

- **Add Source Freshness Check:**
  - In the "Execution Settings," enable the "Run source freshness" option.
  - Discuss the difference between using the checkbox (non-breaking) and adding it as a run step (breaking if freshness fails).

### 3. Create a Snapshot Job

- **Set Up a Snapshot Job:**
  - Create a new job and name it "Snapshot Job."
  - In the "Execution Settings," add the command `dbt snapshot`.
  - Use the timestamp strategy for capturing changes.

### Additional Exercises

#### Source Freshness

- **Objective:** Monitor data freshness to ensure compliance with SLAs.
- **Tasks:**
  - Create a job that runs the `dbt source freshness` command.
  - Schedule it to run at least double the frequency of your lowest SLA.

#### Snapshot

- **Objective:** Track changes in mutable source tables over time.
- **Tasks:**
  - Create a YAML file in the `snapshots` directory for configuration.
  - Run the `dbt snapshot` command and verify the results.

#### Incremental

- **Objective:** Set up incremental jobs for efficient data processing.
- **Tasks:**
  - Define incremental materialization in the model's config block.
  - Use the `--select` syntax to build incremental models.

#### Full Refresh

- **Objective:** Perform a full refresh of incremental models.
- **Tasks:**
  - Use the `--full-refresh` flag with the `dbt run` command.
  - Schedule a full refresh job to run occasionally for data quality.

#### Build

- **Objective:** Understand the dbt build command and its components.
- **Tasks:**
  - Run the `dbt build` command to execute models, tests, snapshots, and seeds.
  - Use the Model Timing tab to analyze performance bottlenecks.
