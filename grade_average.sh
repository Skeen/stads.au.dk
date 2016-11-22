#!/bin/bash
set -e

# Logged-in cookie for stads
COOKIE=$(node index.js $1 $2)
#COOKIE="; selvbetjening=5EGOUHPZvXFYXrYkEHMYzoFZVM1nLW3ZaZ4k5U45rcZKzfjZuERS!-229613275; au_wayf_user=true"
echo "Cookie: $COOKIE"

# Get results website
SITE=$(curl -q --cookie "$COOKIE" https://sbstads.au.dk/sb_STAP/sb/resultater/studresultater.jsp 2>/dev/null)
# Get just the DataValue lines (table), get rid of latin1 characters, and grab cell contents
LINES=$(echo "$SITE" | grep "DataValue" | iconv -f latin1 -t ascii//TRANSLIT | sed "s/.*>\(.*\)<.*/\1/g")
# Check that we got the expected result
if [ -z "$LINES" ]; then
    echo "Cookie invalidated!" 1>&2
    exit 1
fi

# Prepare output files for use with paste
GRADE_FILE=$(mktemp)
ECTS_FILE=$(mktemp)
# Grab the grade lines
echo "$LINES" | sed -n '4~5p' > $GRADE_FILE
# Grab the ECTS lines
echo "$LINES" | sed -n '5~5p' | sed "s/&nbsp;//g" > $ECTS_FILE
# Use paste to combine them into pretty pairs, and remove bad lines (Missed exams, ect).
RESULTS=$(paste $GRADE_FILE $ECTS_FILE | grep -v "&nbsp;")
# Replace ECTS grades with numbers, calculate average
echo "$RESULTS" | sed "s/A/12/" | sed "s/B/10/" | sed "s/C/7/" | sed "s/D/4/" | awk '{print $1 * $2, $2}' | awk '{ gsum += $1; esum += $2 } END { print gsum, esum }' | awk '{ print $1/$2 }'
