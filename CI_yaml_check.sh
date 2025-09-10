#!/bin/bash

echo "Checking if dbt-osmosis YAML files are up to date..."

# Run the command and check its exit code immediately
if dbt-osmosis yaml refactor --check; then
    echo "✅ YAML files are up to date."
    exit 0
else
    echo "❌ YAML files are out of date. Please run 'dbt-osmosis yaml refactor'."
    exit 1 # Fail the script/pipeline
fi
