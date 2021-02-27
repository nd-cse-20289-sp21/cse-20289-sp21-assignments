#!/bin/bash

export PATH=/escnfs/home/pbui/pub/pkgsrc/bin:$PATH

# Configuration

SCRIPT=unique.py
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

input() {
    cat <<EOF
leonardo
Donatello
Leonardo
Michelangelo
donatello
Raphael
donatello
leonardo
Michelangelo
Leonardo
EOF
}

output() {
    cat <<EOF
leonardo
Donatello
Leonardo
Michelangelo
donatello
Raphael
EOF
}

output_i() {
    cat <<EOF
leonardo
donatello
michelangelo
raphael
EOF
}

output_c() {
    cat <<EOF
      2 leonardo
      1 Donatello
      2 Leonardo
      2 Michelangelo
      2 donatello
      1 Raphael
EOF
}

output_ic() {
    cat <<EOF
      4 leonardo
      3 donatello
      2 michelangelo
      1 raphael
EOF
}

output_d() {
    cat <<EOF
leonardo
Leonardo
Michelangelo
donatello
EOF
}

output_id() {
    cat <<EOF
leonardo
donatello
michelangelo
EOF
}

output_cd() {
    cat <<EOF
      2 leonardo
      2 Leonardo
      2 Michelangelo
      2 donatello
EOF
}

output_icd() {
    cat <<EOF
      4 leonardo
      3 donatello
      2 michelangelo
EOF
}

output_u() {
    cat <<EOF
Donatello
Raphael
EOF
}

output_iu() {
    cat <<EOF
raphael
EOF
}

output_cu() {
    cat <<EOF
      1 Donatello
      1 Raphael
EOF
}

output_icu() {
    cat <<EOF
      1 raphael
EOF
}

# Setup

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

# Tests

echo "Testing $SCRIPT ..."

printf "   %-40s ... " "Unit Tests"
./unique_test.py -v &> $WORKSPACE/test
TOTAL=$(grep 'Ran.*tests' $WORKSPACE/test | awk '{print $2}')
PASSED=$(grep -c '... ok' $WORKSPACE/test)
UNITS=$(echo "scale=2; ($PASSED / $TOTAL) * 2.0" | bc)
echo "$UNITS / 2.00"

rm -f $WORKSPACE/test

printf "   %-40s ... " "Usage"
./$SCRIPT -h 2>&1 | grep -i usage 2>&1 > /dev/null
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique"
diff -y <(input | ./$SCRIPT) <(output) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -i"
diff -y <(input | ./$SCRIPT -i) <(output_i) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -c"
diff -y <(input | ./$SCRIPT -c) <(output_c) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -i -c"
diff -y <(input | ./$SCRIPT -i -c) <(output_ic) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -d"
diff -y <(input | ./$SCRIPT -d) <(output_d) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -i -d"
diff -y <(input | ./$SCRIPT -i -d) <(output_id) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -c -d"
diff -y <(input | ./$SCRIPT -c -d) <(output_cd) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -i -c -d"
diff -y <(input | ./$SCRIPT -i -c -d) <(output_icd) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -u"
diff -y <(input | ./$SCRIPT -u) <(output_u) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -i -u"
diff -y <(input | ./$SCRIPT -i -u) <(output_iu) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -c -u"
diff -y <(input | ./$SCRIPT -c -u) <(output_cu) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Unique -i -c -u"
diff -y <(input | ./$SCRIPT -i -c -u) <(output_icu) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))

echo
echo "   Score $(echo "scale=2; $UNITS + ($TESTS - $FAILURES) / $TESTS.0 * 3.0" | bc)"
echo
