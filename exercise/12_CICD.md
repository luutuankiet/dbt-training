# Exercise 3: CI/CD Integration

## Objective

Implement CI/CD workflows using dbt Cloud and GitHub.

## Instructions

### 1. Set Up a CI Job

- **Create a CI Job:**
  - Navigate to the "Jobs" section in dbt Cloud.
  - Click "Create Job" and select "Continuous Integration Job."
  - Name the job, e.g., "CI for Pull Requests."

- **Configure the CI Job:**
  - In the "Git Trigger" section, enable "Triggered by pull requests."
  - Add the command `dbt build --select state:modified+` to build only modified models and their dependencies.
  - Enable linting to check SQL files for quality and formatting errors.

- **Test the CI Job:**
  - Open a pull request in your GitHub repository.
  - Verify that the CI job is triggered and runs successfully.

### 2. Create a Merge Job for CD

- **Set Up a Merge Job:**
  - Create a new job and select "Merge Job."
  - Name the job, e.g., "CD on Merge."

- **Configure the Merge Job:**
  - In the "Git Trigger" section, enable "Run on merge."
  - Add the command `dbt build --select state:modified+` to build only modified models.
  - Use state comparison to ensure only changed models are built.

- **Test the Merge Job:**
  - Merge a pull request in your GitHub repository.
  - Verify that the merge job is triggered and runs successfully.

### Additional Exercises

#### Linting and Testing

- **Objective:** Ensure code quality and correctness.
- **Tasks:**
  - Add a linting step to the CI job to check for SQL syntax errors.
  - Include `dbt test` in the CI job to run tests on modified models.

#### Environment Configuration

- **Objective:** Understand the importance of environment settings in CI/CD.
- **Tasks:**
  - Configure the CI job to run in a staging environment.
  - Discuss the benefits of isolating CI/CD processes from production data.