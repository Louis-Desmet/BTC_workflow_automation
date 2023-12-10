#!/bin/bash
set -euo pipefail

#Globaal script om alle scripts te runnen

cd "$(dirname "$0")"

echo "Starting Data Workflow..."

echo "Fetching Raw Data..."
./raw_data/fetch_raw_data.sh

echo "Transforming Data..."
./transform_data/transform_data.sh

echo "Analyzing Data..."
(cd data_analysis && python3 analysis.py)

echo "Generating Report..."
./data_analysis/makeReport.sh

echo "Data Workflow Completed Successfully."
