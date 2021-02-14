#!/bin/bash

export PATH=/escnfs/home/pbui/pub/pkgsrc/bin:$PATH

# Configuration

SCRIPT=weather.sh
WORKSPACE=/tmp/$SCRIPT.$(id -u)
FAILURES=0

# Functions

error() {
    echo "$@"
    [ -r $WORKSPACE/test ] && cat $WORKSPACE/test
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    STATUS=${1:-$FAILURES}
    rm -fr $WORKSPACE
    exit $STATUS
}

weather() {
    python3 <<EOF
import requests

url      = "https://forecast.weather.gov/zipcity.php?inputstring=$1"
response = requests.get(url)

for line in response.text.splitlines():
    line = line.strip()
    if 'forecast' in "$2" and '"myforecast-current"' in line:
        forecast = line.split('>')[1].split('<')[0].strip()
        print(f'Forecast:    {forecast}')

    if 'celsius' in "$2" and 'myforecast-current-sm' in line:
        temperature = line.split('>')[1].split('&')[0]
        print(f'Temperature: {temperature} degrees')
    
    if not 'celsius' in "$2" and 'myforecast-current-lrg' in line:
        temperature = line.split('>')[1].split('&')[0]
        print(f'Temperature: {temperature} degrees')
EOF
}

# Setup

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

# Tests

echo "Testing $SCRIPT ..."

printf "   %-40s ... " Usage
./$SCRIPT -h 2>&1 | grep -i usage 2>&1 > /dev/null
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " Default
diff -u <(./$SCRIPT) <(weather 46556) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " 46556
diff -u <(./$SCRIPT) <(weather 46556) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "46556 Celsius"
diff -u <(./$SCRIPT -c) <(weather 46556 celsius) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "46556 Forecast"
diff -u <(./$SCRIPT -f) <(weather 46556 forecast) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "46556 Celsius Forecast"
diff -u <(./$SCRIPT -c -f) <(weather 46556 "celsius forecast") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " 54701
diff -u <(./$SCRIPT 54701) <(weather 54701) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "54701 Celsius"
diff -u <(./$SCRIPT -c 54701) <(weather 54701 celsius) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "54701 Forecast"
diff -u <(./$SCRIPT -f 54701) <(weather 54701 forecast) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "54701 Celsius Forecast"
diff -u <(./$SCRIPT -c -f 54701) <(weather 54701 "celsius forecast") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " 92867
diff -u <(./$SCRIPT 92867) <(weather 92867) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "92867 Celsius"
diff -u <(./$SCRIPT -c 92867) <(weather 92867 celsius) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "92867 Forecast"
diff -u <(./$SCRIPT -f 92867) <(weather 92867 forecast) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "92867 Celsius Forecast"
diff -u <(./$SCRIPT -c -f 92867) <(weather 92867 "celsius forecast") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))

echo
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 4.0" | bc)"
echo
