#!/bin/bash

RESULT_FILE="/tmp/conky-daylight-inf.result"
ANSWER_FILE="/tmp/conky-daylight-inf.answer."`date "+%d%m%y%H%M%S"`

# Remove old file
rm ${RESULT_FILE} 2> /dev/null

# Get the HTML file from server
curl --silent --output ${ANSWER_FILE} "http://www.wolframalpha.com/input/?i=sun"

# Check if the file was returned
if [[ ! -f ${ANSWER_FILE} ]]; then
	echo "No answer from server" >> ${RESULT_FILE}
	exit 1
fi

# Parse the file and get info

# Location info
# LOC_INFO=`sed -n 's/.*Daylight information for \(.*\):<.*/\1/p' ${ANSWER_FILE} | head -n 1`
# echo ${LOC_INFO} >> ${RESULT_FILE}

# Sunrise
# Filter "sunrise | xx:xx am"
SUNRISE=`sed -n 's/.*sunrise | \([0-9]\{1,2\}:[0-9]\{1,2\}\) am.*/\1/p' ${ANSWER_FILE} | head -n 1`
echo "Zon op | ${SUNRISE}" >> ${RESULT_FILE}

# Sunset
# Filter "sunset | xx:xx pm"
SUNSET=`sed -n 's/.*sunset | \([0-9]\{1,2\}:[0-9]\{1,2\}\) pm.*/\1/p' ${ANSWER_FILE} | head -n 1`
echo " Zon onder | ${SUNSET}" >> ${RESULT_FILE}

# Duration of daylight
# Filter "duration of daylight | xx hours  56 minute"
# DURATION=`sed -n 's/.*duration of daylight | \([0-9]\{1,2\}\) hours  \([0-9]\{1,2\}\) minute.*/\1:\2/p' ${ANSWER_FILE} | head -n 1`
# echo " Lengte dag | ${DURATION}" >> ${RESULT_FILE}

# Refresh conky
killall -SIGUSR1 conky
