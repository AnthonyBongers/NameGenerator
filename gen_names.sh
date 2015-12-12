#!/bin/bash

# Ignore everything but the names (in $1), and separate them by commas
AWK_STR='{ if (length(names) > 0) { names=names "," } names=names "\"" $1 "\"" } END { print names }'

# Download male, female, and last names from the census website and format it with the Awk script above
echo 'Downloading male names...'
MALE_NAMES=$(curl -# http://www2.census.gov/topics/genealogy/1990surnames/dist.male.first | awk "$AWK_STR")

echo 'Downloading female names...'
FEMALE_NAMES=$(curl -# http://www2.census.gov/topics/genealogy/1990surnames/dist.female.first | awk "$AWK_STR")

echo 'Downloading last names...'
LAST_NAMES=$(curl -# http://www2.census.gov/topics/genealogy/1990surnames/dist.all.last | awk "$AWK_STR")

# Insert the parsed data into json
echo 'Formatting data...'
JSON=$(echo "{\"male\":[$MALE_NAMES],\"female\":[$FEMALE_NAMES],\"last\":[$LAST_NAMES]}")

# Format the names from all uppercase, to only the first letter uppercased (ANTHONY -> Anthony)
FORMATTED=$(echo "$JSON" | perl -pe 's/(\w)(\w*)/$1\L$2/g')

# Save the result into the file names.txt
echo "$FORMATTED" > names.json
echo 'File saved as names.json!'