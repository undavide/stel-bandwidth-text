#!/bin/bash

DEFAULT_RUNS=5
PAUSE_SECONDS=1

if [ -z "$1" ]; then
  NUM_RUNS=$DEFAULT_RUNS
else
  NUM_RUNS=$1
fi

data_dir="data"
if [ ! -d "$data_dir" ]; then
  mkdir "$data_dir"
fi

echo "Running speed tests $NUM_RUNS times..."

results_array="["

for i in $(seq 1 $NUM_RUNS); do
  echo "Running test $i..."
  result=$(speedtest --server-id=4302 --format=json-pretty)
  results_array+=$result

  if [ $i -lt $NUM_RUNS ]; then
    results_array+=","
    sleep $PAUSE_SECONDS
  fi
done

results_array+="]"

# Set the time zone to Italy
TZ='Europe/Rome'
export TZ

timestamp=$(date +%Y%m%d_%H%M%S)
output_file="$data_dir/speedtest_results_${timestamp}.json"
echo $results_array > $output_file
echo "Results saved to $output_file"
