#!/bin/bash

WORKSPACE=/tmp/sort.$(id -u)
FAILURES=0

error() {
    echo "$@"
    [ -r $WORKSPACE/test ] && (echo; cat $WORKSPACE/test; echo)
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    STATUS=${1:-$FAILURES}
    rm -fr $WORKSPACE
    exit $STATUS
}

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

echo
echo "Testing sort ..."

printf " %-40s ... " "sort 1"
shuf -i 1-1 | ./sort | diff -y - <(seq 1) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "sort 1 10"
shuf -i 1-10 | ./sort | diff -y - <(seq 1 10) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "sort 1 100"
shuf -i 1-100 | ./sort | diff -y - <(seq 1 100) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "sort 1 1000"
shuf -i 1-1000 | ./sort | diff -y - <(seq 1 1000) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "sort 1 1000 (valgrind)"
shuf -i 1-1000 | valgrind --leak-check=full ./sort &> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi


TESTS=$(($(grep -c Success $0) - 1))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 1.0" | bc)"
