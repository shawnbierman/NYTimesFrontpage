#!/bin/bash
# Download the New York Times front page PDF for a specific date.
# Usage examples:
#   ./getNYTFrontPage.sh            # Download today's front page
#   ./getNYTFrontPage.sh -d 1       # Download yesterday's front page
#   ./getNYTFrontPage.sh -d 7       # Download front page from 7 days ago
#   ./getNYTFrontPage.sh -y 1       # Download front page from one year ago
#   ./getNYTFrontPage.sh -d 1 -y 2  # Download front page from 2 years and 1 day ago

# Default offset in days
offset=0

# Parse arguments
while getopts "d:y:" opt; do
  case $opt in
    d)
      if ! [[ $OPTARG =~ ^[0-9]+$ ]]; then
        echo "Error: -d requires a positive integer argument." >&2
        exit 1
      fi
      ((offset += OPTARG))
      ;;
    y)
      if ! [[ $OPTARG =~ ^[0-9]+$ ]]; then
        echo "Error: -y requires a positive integer argument." >&2
        exit 1
      fi
      ((offset += OPTARG * 365))
      ;;
    *)
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $0 [-d days] [-y years]" >&2
      exit 1
      ;;
  esac
done

shift $((OPTIND -1))

# Check for extra arguments
if [ $# -gt 0 ]; then
  echo "Invalid argument(s): $@" >&2
  echo "Usage: $0 [-d days] [-y years]" >&2
  exit 1
fi

# Calculate the target date
if [ "$offset" -eq 0 ]; then
  target_date=$(date '+%Y-%m-%d')
else
  # Adjust date calculation for macOS and Linux
  if date -v -1d &>/dev/null; then
    # BSD date (macOS)
    target_date=$(date -v-"$offset"d '+%Y-%m-%d')
  else
    # GNU date
    target_date=$(date -d "-$offset days" '+%Y-%m-%d')
  fi
fi

# Extract year, month, and day from the target date
year=${target_date:0:4}
month=${target_date:5:2}
day=${target_date:8:2}

echo "Downloading NYT front page for date: $year-$month-$day"

# Download the front page
url="https://static01.nyt.com/images/$year/$month/$day/nytfrontpage/scan.pdf"
output_file="NYTimes-FrontPage-$month-$day-$year.pdf"

if curl -o "$output_file" "$url"; then
  echo "Download successful."
  open "$output_file"
else
  echo "Failed to download the file. The front page may not be available for the specified date."
  exit 1
fi

