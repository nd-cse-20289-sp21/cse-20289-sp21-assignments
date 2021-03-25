#!/bin/bash

WORKSPACE=/tmp/grep.$(id -u)
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
echo "Testing grep ..."

printf " %-40s ... " "grep usage (-h)"
if ! ./grep -h |& grep -q -i usage; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "grep usage (no arguments)"
if ! ./grep |& grep -q -i usage; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "grep root /etc/passwd"
valgrind --leak-check=full ./grep root < /etc/passwd &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "grep root /etc/passwd (valgrind)"
if [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "grep login /etc/passwd"
valgrind --leak-check=full ./grep login < /etc/passwd &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "grep login /etc/passwd (valgrind)"
if [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "grep asdf /etc/passwd"
valgrind --leak-check=full ./grep asdf < /etc/passwd &> $WORKSPACE/test
if [ $? -eq 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "grep asdf /etc/passwd (valgrind)"
if [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 1.0" | bc)"
