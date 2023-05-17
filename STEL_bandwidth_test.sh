#!/bin/bash

echo "Starting the speedtest process..."

# Run the first script and wait for it to finish
echo "Running 1_run_speedtests.sh..."
#./scripts/1_run_speedtests.sh
sleep 1

# Run the second script and wait for it to finish
echo "Running 2_average_results.sh..."
./scripts/2_average_results.sh
sleep 1

# Run the third script and wait for it to finish
echo "Running 3_generate_csv_from_txt.sh..."
./scripts/3_generate_csv_from_txt.sh
sleep 1

# Run the fourth script and wait for it to finish
echo "Running 4_run_plot.sh..."
./scripts/4_run_plot.sh

echo "Speedtest process completed!"