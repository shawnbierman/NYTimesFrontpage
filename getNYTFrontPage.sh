#/bin/bash

month=`date +%m`
day=`date +%d`
year=`date +%Y`

echo $month

curl https://static01.nyt.com/images/$year/$month/$day/nytfrontpage/scan.pdf --output NYTimes-FrontPage-$month-$day-$year.pdf

