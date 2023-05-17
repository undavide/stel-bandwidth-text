#!/bin/bash

reports_dir="./reports"
csv_file="./reports/speedtest_data.csv"

# Write the CSV header
echo "Timestamp,Avg Download (Mbps),Min Download (Mbps),Max Download (Mbps),Avg Upload (Mbps),Min Upload (Mbps),Max Upload (Mbps)" > $csv_file

for input_file in "${reports_dir}/speedtest_averages_"*.txt
do
  timestamp=$(echo $input_file | awk -F'[_.]' '{print $(NF-2) "_" $(NF-1)}')

  # Convert the timestamp to ISO 8601 format in the Italian timezone
  iso_timestamp=$(TZ='Europe/Rome' date -jf '%Y%m%d_%H%M%S' "$timestamp" '+%Y-%m-%dT%H:%M:%S%z')

  # Extract the respective values
  avg_download=$(grep -A3 'Download Speeds:' $input_file | grep 'Average:' | awk '{printf "%.2f", $2}')
  min_download=$(grep -A3 'Download Speeds:' $input_file | grep 'Min:' | awk '{printf "%.2f", $2}')
  max_download=$(grep -A3 'Download Speeds:' $input_file | grep 'Max:' | awk '{printf "%.2f", $2}')

  avg_upload=$(grep -A3 'Upload Speeds:' $input_file | grep 'Average:' | awk '{printf "%.2f", $2}')
  min_upload=$(grep -A3 'Upload Speeds:' $input_file | grep 'Min:' | awk '{printf "%.2f", $2}')
  max_upload=$(grep -A3 'Upload Speeds:' $input_file | grep 'Max:' | awk '{printf "%.2f", $2}')

  # Write the data to the CSV file
  echo "$iso_timestamp,$avg_download,$min_download,$max_download,$avg_upload,$min_upload,$max_upload" >> $csv_file
done

echo "CSV file generated: $csv_file"
