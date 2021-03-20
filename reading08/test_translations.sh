#!/bin/bash

WORKSPACE=/tmp/translations.$(id -u)
FAILURES=0

error() {
    echo "$@"
    echo
    [ -r $WORKSPACE/test ] && cat $WORKSPACE/test
    echo
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

echo "Testing translations ..."

printf " %-40s ... " "translate1.py"
./translate1.py | diff -y - <(grep -Po '9\d*9' /etc/passwd | wc -l) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "translate2.py"
./translate2.py | diff -y - <(cut -d : -f 5 /etc/passwd | grep -Po '[Uu]ser' | wc -l) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "translate3.py"
./translate3.py | diff -y - <(curl -sLk http://yld.me/raw/Hk1 | cut -d , -f 2 | grep -Eo '^B.*' | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "translate4.py"
./translate4.py | sort -rn | diff -y - <(/bin/ls -l /etc | awk '{print $2}' | sort | uniq -c | sort -rn) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 2.0" | bc | awk '{printf "%0.2f\n", $1}')"
echo
