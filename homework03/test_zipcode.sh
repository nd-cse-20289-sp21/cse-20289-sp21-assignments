#!/bin/sh

# Configuration

SCRIPT=zipcode.sh
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
if [ $(./$SCRIPT | wc -l) -ne 988 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Indiana"
if [ $(./$SCRIPT -s Indiana | wc -l) -ne 988 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Notre Dame, Indiana"
if [ $(./$SCRIPT -s Indiana -c "Notre Dame" | wc -l) -ne 1 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "South Bend, Indiana"
if [ $(./$SCRIPT -s Indiana -c "South Bend" | wc -l) -ne 18 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "California"
if [ $(./$SCRIPT -s California | wc -l) -ne 2657 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Orange, California"
if [ $(./$SCRIPT -s California -c "Orange" | wc -l) -ne 11 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Los Angeles, California"
if [ $(./$SCRIPT -s California -c "Los Angeles" | wc -l) -ne 97 ]; then
    error "Failed Los Angeles, California Test"
else
    echo "Success"
fi

printf "   %-40s ... " "New York"
if [ $(./$SCRIPT -s "New York" | wc -l) -ne 2205 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Buffalo, New York"
if [ $(./$SCRIPT -s "New York" -c "Buffalo" | wc -l) -ne 44 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "New York, New York"
if [ $(./$SCRIPT -s "New York" -c "New York" | wc -l) -ne 162 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))

echo
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 4.0" | bc)"
echo
