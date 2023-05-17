# #!/bin/bash

# reports_dir="reports"
# if [ ! -d "$reports_dir" ]; then
#   mkdir "$reports_dir"
# fi

# data_dir="data"
# for input_file in "${data_dir}/speedtest_results_"*.json
# # for input_file in *speedtest_results_*.json
# do
#   timestamp=$(echo $input_file | awk -F'[_.]' '{print $(NF-2) "_" $(NF-1)}')
#   output_file="$reports_dir/speedtest_averages_$timestamp.txt"

#   if [ ! -f "$output_file" ]; then
#     download_speeds=$(jq '[.[] | .download.bandwidth / 125000] | map(tonumber)' $input_file)
#     upload_speeds=$(jq '[.[] | .upload.bandwidth / 125000] | map(tonumber)' $input_file)

#     download_avg=$(echo $download_speeds | jq 'add / length' -)
#     download_min=$(echo $download_speeds | jq 'min' -)
#     download_max=$(echo $download_speeds | jq 'max' -)

#     upload_avg=$(echo $upload_speeds | jq 'add / length' -)
#     upload_min=$(echo $upload_speeds | jq 'min' -)
#     upload_max=$(echo $upload_speeds | jq 'max' -)

#     total_runs=$(echo $download_speeds | jq 'length' -)

#     download_avg_formatted=$(printf "%.2f" $download_avg)
#     upload_avg_formatted=$(printf "%.2f" $upload_avg)

#     date_time_it=$(python -c "import datetime; dt = datetime.datetime.strptime('$timestamp', '%Y%m%d_%H%M%S'); print(dt.strftime('%d %B %Y, %H:%M:%S'))")

#     echo "Timestamp: $date_time_it" >> $output_file
#     echo "Total Runs: $total_runs" >> $output_file
#     echo "Download Speeds:" >> $output_file
#     echo "  Average: $download_avg_formatted Mbps" >> $output_file
#     echo "  Min:     $download_min Mbps" >> $output_file
#     echo "  Max:     $download_max Mbps" >> $output_file

#     echo "Upload Speeds:" >> $output_file
#     echo "  Average: $upload_avg_formatted Mbps" >> $output_file
#     echo "  Min:     $upload_min Mbps" >> $output_file
#     echo "  Max:     $upload_max Mbps" >> $output_file
#   fi
# done

#!/bin/bash

reports_dir="reports"
if [ ! -d "$reports_dir" ]; then
  mkdir "$reports_dir"
fi

data_dir="data"
for input_file in "${data_dir}/speedtest_results_"*.json
do
  timestamp=$(echo $input_file | awk -F'[_.]' '{print $(NF-2) "_" $(NF-1)}')
  output_file="$reports_dir/speedtest_averages_$timestamp.txt"

  if [ ! -f "$output_file" ]; then
    valid_results=$(jq '[.[] | select(has("error") | not)]' $input_file)

    download_speeds=$(echo $valid_results | jq '[.[] | .download.bandwidth / 125000] | map(tonumber)')
    upload_speeds=$(echo $valid_results | jq '[.[] | .upload.bandwidth / 125000] | map(tonumber)')

    download_avg=$(echo $download_speeds | jq 'add / length' -)
    download_min=$(echo $download_speeds | jq 'min' -)
    download_max=$(echo $download_speeds | jq 'max' -)

    upload_avg=$(echo $upload_speeds | jq 'add / length' -)
    upload_min=$(echo $upload_speeds | jq 'min' -)
    upload_max=$(echo $upload_speeds | jq 'max' -)

    total_runs=$(echo $download_speeds | jq 'length' -)

    download_avg_formatted=$(printf "%.2f" $download_avg)
    upload_avg_formatted=$(printf "%.2f" $upload_avg)

    date_time_it=$(python -c "import datetime; dt = datetime.datetime.strptime('$timestamp', '%Y%m%d_%H%M%S'); print(dt.strftime('%d %B %Y, %H:%M:%S'))")

    echo "Timestamp: $date_time_it" >> $output_file
    echo "Total Runs: $total_runs" >> $output_file
    echo "Download Speeds:" >> $output_file
    echo "  Average: $download_avg_formatted Mbps" >> $output_file
    echo "  Min:     $download_min Mbps" >> $output_file
    echo "  Max:     $download_max Mbps" >> $output_file

    echo "Upload Speeds:" >> $output_file
    echo "  Average: $upload_avg_formatted Mbps" >> $output_file
    echo "  Min:     $upload_min Mbps" >> $output_file
    echo "  Max:     $upload_max Mbps" >> $output_file
  fi
  
  error_count=$(jq '[.[] | select(has("error"))] | length' $input_file)
  if [ $error_count -gt 0 ]; then
    echo "WARNING: $error_count error(s) found in $input_file and were skipped." >&2
  fi
done
