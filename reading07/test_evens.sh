#!/bin/bash

SCRIPT=${1:-evens.py}
WORKSPACE=/tmp/$SCRIPT.$(id -u)
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

echo "Testing $SCRIPT ..."

printf " %-40s ... " "$SCRIPT on seq 1 10"
seq 1 10 | ./$SCRIPT | diff -y - <(echo "2 4 6 8 10") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "$SCRIPT on seq 10 20"
seq 10 20 | ./$SCRIPT | diff -y - <(echo "10 12 14 16 18 20") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "$SCRIPT on seq 1 1000000 (count)"
seq 1 1000000 | ./$SCRIPT | wc -w | sed -E 's/^[ \t]+//' | diff -y - <(echo "500000") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "$SCRIPT no list()"
if [ ! -x "$SCRIPT" ] || grep -q 'list(' $SCRIPT; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "$SCRIPT structure"
case $SCRIPT in
    *evens_fp*)
    echo "Wrong functional programming structure: filter(lambda _: _, map(_))" > $WORKSPACE/test
    grep -Eq 'filter.*lambda.*map' $SCRIPT
    ;;
    *evens_lc*)
    echo "Wrong list comprehension structure: [ _ for _ in _ if _ ]" > $WORKSPACE/test
    grep -Eq '\[.*for.*in.*if.*\]' $SCRIPT
    ;;
    *evens_gr*)
    echo "Missing yield" > $WORKSPACE/test
    grep -Eq 'yield' $SCRIPT
    ;;
esac
if [ $? -ne 0 ] || [ ! -x "$SCRIPT" ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))

echo
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 1.0" | bc)"
echo
