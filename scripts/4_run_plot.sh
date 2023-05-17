#!/bin/bash

# Get the absolute path of the CSV file
csv_file="$(pwd)/reports/speedtest_data.csv"

# Pass the absolute path to the Python script
python ./scripts/plot_data.py "$csv_file"
