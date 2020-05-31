#/bin/bash

month=`date +%m`
day=`date +%d`
year=`date +%Y`

echo $month

echo curl https://static01.nyt.com/images/$year/$month/$day/nytfrontpage/scan.pdf --output NYTimes-FrontPage-$month-$day-$year.pdf
curl https://static01.nyt.com/images/$year/$month/$day/nytfrontpage/scan.pdf --output NYTimes-FrontPage-$month-$day-$year.pdf

open NYTimes-FrontPage-$month-$day-$year.pdf
