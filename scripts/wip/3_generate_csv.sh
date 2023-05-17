# #!/bin/bash

# data_dir="data"
# reports_dir="reports"

# if [ ! -d "$reports_dir" ]; then
#   mkdir "$reports_dir"
# fi

# csv_file="$reports_dir/speedtest_data.csv"

# # Write the CSV header
# echo "Timestamp,Avg Download (Mbps),Min Download (Mbps),Max Download (Mbps),Avg Upload (Mbps),Min Upload (Mbps),Max Upload (Mbps)" > $csv_file

# for input_file in "${data_dir}/speedtest_results_"*.json
# do
#   timestamp=$(echo $input_file | awk -F'[_.]' '{print $(NF-2) "_" $(NF-1)}')

#   download_speeds=$(jq '[.[] | .download.bandwidth / 125000] | map(tonumber)' $input_file)
#   upload_speeds=$(jq '[.[] | .upload.bandwidth / 125000] | map(tonumber)' $input_file)

#   download_avg=$(echo $download_speeds | jq 'add / length' -)
#   download_min=$(echo $download_speeds | jq 'min' -)
#   download_max=$(echo $download_speeds | jq 'max' -)

#   upload_avg=$(echo $upload_speeds | jq 'add / length' -)
#   upload_min=$(echo $upload_speeds | jq 'min' -)
#   upload_max=$(echo $upload_speeds | jq 'max' -)

#   download_avg_formatted=$(printf "%.2f" $download_avg)
#   download_min_formatted=$(printf "%.2f" $download_min)
#   download_max_formatted=$(printf "%.2f" $download_max)

#   upload_avg_formatted=$(printf "%.2f" $upload_avg)
#   upload_min_formatted=$(printf "%.2f" $upload_min)
#   upload_max_formatted=$(printf "%.2f" $upload_max)

#   # Convert the timestamp to ISO 8601 format in the Italian timezone
#   iso_timestamp=$(TZ='Europe/Rome' date -jf '%Y%m%d_%H%M%S' "$timestamp" '+%Y-%m-%dT%H:%M:%S%z')

#   # Write the data to the CSV file
#   echo "$iso_timestamp,$download_avg_formatted,$download_min_formatted,$download_max_formatted,$upload_avg_formatted,$upload_min_formatted,$upload_max_formatted" >> $csv_file
# done

# echo "CSV file generated: $csv_file"

#!/bin/bash

data_dir="data"
reports_dir="reports"

if [ ! -d "$reports_dir" ]; then
  mkdir "$reports_dir"
fi

csv_file="$reports_dir/speedtest_data.csv"

# Write the CSV header
echo "Timestamp,Avg Download (Mbps),Min Download (Mbps),Max Download (Mbps),Avg Upload (Mbps),Min Upload (Mbps),Max Upload (Mbps)" > $csv_file

for input_file in "${data_dir}/speedtest_results_"*.json
do
  timestamp=$(echo $input_file | awk -F'[_.]' '{print $(NF-2) "_" $(NF-1)}')

  # Process each object in the JSON array individually
  length=$(jq 'length' $input_file)
  for ((i=0;i<$length;i++));
  do
    error=$(jq -r ".[$i].error" $input_file)
    # Check if the error property exists, if so skip this object and print a warning
    if [ "$error" != "null" ]; then
      echo "Warning: Skipping object with error: '$error' in:\n$input_file"
      continue
    fi

    download_speeds=$(jq "[.[$i] | .download.bandwidth / 125000]" $input_file)
    upload_speeds=$(jq "[.[$i] | .upload.bandwidth / 125000]" $input_file)

    download_avg=$(echo $download_speeds | jq 'add / length' -)
    download_min=$(echo $download_speeds | jq 'min' -)
    download_max=$(echo $download_speeds | jq 'max' -)

    upload_avg=$(echo $upload_speeds | jq 'add / length' -)
    upload_min=$(echo $upload_speeds | jq 'min' -)
    upload_max=$(echo $upload_speeds | jq 'max' -)

    download_avg_formatted=$(printf "%.2f" $download_avg)
    download_min_formatted=$(printf "%.2f" $download_min)
    download_max_formatted=$(printf "%.2f" $download_max)

    upload_avg_formatted=$(printf "%.2f" $upload_avg)
    upload_min_formatted=$(printf "%.2f" $upload_min)
    upload_max_formatted=$(printf "%.2f" $upload_max)

    # Convert the timestamp to ISO 8601 format in the Italian timezone
    iso_timestamp=$(TZ='Europe/Rome' date -jf '%Y%m%d_%H%M%S' "$timestamp" '+%Y-%m-%dT%H:%M:%S%z')

    # Write the data to the CSV file
    echo "$iso_timestamp,$download_avg_formatted,$download_min_formatted,$download_max_formatted,$upload_avg_formatted,$upload_min_formatted,$upload_max_formatted" >> $csv_file
  done
done

echo "CSV file generated: $csv_file"
