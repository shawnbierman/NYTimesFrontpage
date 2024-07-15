#!/bin/bash

# Initialize the offsets
day_offset=0
year_offset=0

# Parse arguments
while getopts "d:y:" opt; do
  case $opt in
    d) 
      day_offset=$OPTARG
      ;;
    y)
      year_offset=$(($OPTARG * 365))
      ;;
    *)
      echo "Invalid option: -$opt" >&2
      exit 1
      ;;
  esac
done

# Calculate the total offset in days
offset=$(($day_offset + $year_offset))

# Calculate the target date
if [ "$offset" -eq 0 ]; then
  target_date=$(date +%Y-%m-%d)
else
  target_date=$(date -v-"$offset"d +%Y-%m-%d)
fi

# Extract year, month, and day from the target date
year=$(echo $target_date | cut -d'-' -f1)
month=$(echo $target_date | cut -d'-' -f2)
day=$(echo $target_date | cut -d'-' -f3)

echo "Downloading NYT front page for date: $year-$month-$day"

# Download the front page
url="https://static01.nyt.com/images/$year/$month/$day/nytfrontpage/scan.pdf"
output_file="NYTimes-FrontPage-$month-$day-$year.pdf"

echo "curl $url --output $output_file"
curl $url --output $output_file

# Open the downloaded PDF
open $output_file
