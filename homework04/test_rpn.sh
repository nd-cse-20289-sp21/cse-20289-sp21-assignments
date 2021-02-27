#!/bin/bash

export PATH=/escnfs/home/pbui/pub/pkgsrc/bin:$PATH

# Configuration

SCRIPT=rpn.py
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

# Test Cases

input1() {
    cat <<EOF
65 13 /
7 2 +
8 4 / 8 * 9 + -20 -
EOF
}

output1() {
    cat <<EOF
5.0
9.0
45.0
EOF
}

input2() {
    cat <<EOF
3
3 5 -
4 3 + 2 * 8 + 11 / 2 /
-4 3 + -1 * -3 - -2 /
32 16 /
EOF
}

output2() {
    cat <<EOF
3.0
-2.0
1.0
-2.0
2.0
EOF
}

input3() {
    cat <<EOF
5 8 * 1 +
5 1 2 + 4 * + 3 -
1 2 + 4 * 5 + 3 -
-1 5 *
2 3 + 3 * 100 11 - * 2 +
15 7 1 1 + - / 3 * 2 1 1 + + -
-1 -1 *
1 -1 *
-1 1 *
EOF
}

output3() {
    cat <<EOF
41.0
14.0
14.0
-5.0
1337.0
5.0
1.0
-1.0
-1.0
EOF
}

# Setup

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

# Tests

echo "Testing $SCRIPT ..."

printf "   %-40s ... " "Doctests"
grep -q '>>> evaluate_expression' $SCRIPT
if [ $? -ne 0 ]; then
    UNITS=0
    echo "MISSING"
else
    python3 -m doctest -v $SCRIPT 2> /dev/null > $WORKSPACE/test
    TOTAL=$(grep 'tests.*items' $WORKSPACE/test | awk '{print $1}')
    PASSED=$(grep 'passed.*failed' $WORKSPACE/test | awk '{print $1}')
    UNITS=$(echo "scale=2; ($PASSED / $TOTAL) * 2.0" | bc)
    echo "$UNITS / 2.00"
fi

rm -f $WORKSPACE/test

printf "   %-40s ... " "Usage"
./$SCRIPT -h 2>&1 | grep -i usage 2>&1 > /dev/null
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Expressions 1"
diff -y <(input1 | ./$SCRIPT) <(output1) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Expressions 2"
diff -y <(input2 | ./$SCRIPT) <(output2) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Expressions 3"
diff -y <(input3 | ./$SCRIPT) <(output3) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))

echo
echo "   Score $(echo "scale=2; $UNITS + ($TESTS - $FAILURES) / $TESTS.0 * 3.0" | bc)"
echo
