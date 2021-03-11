#!/bin/bash

SCRIPT=${1:-hulk.py}
WORKSPACE=/tmp/$SCRIPT.$(id -u)
FAILURES=0

error() {
    echo "$@"
    [ -s $WORKSPACE/test ] && (echo ; cat $WORKSPACE/test; echo; rm $WORKSPACE/test)
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

printf "   %-40s ... " "Unit Tests"
./hulk_test.py -v &> $WORKSPACE/test
TOTAL=$(grep 'Ran.*tests' $WORKSPACE/test | awk '{print $2}')
PASSED=$(grep -c '... ok' $WORKSPACE/test)
UNITS=$(echo "scale=2; ($PASSED / $TOTAL) * 2.0" | bc)
echo "$UNITS / 2.00"

printf "   %-40s ... " "Usage"
if ! ./hulk.py -h 2>&1 | grep -q -i usage > /dev/null; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 1"
timeout 1 ./$SCRIPT -s hashes.txt -l 1 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 16 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 1 (ALPHABET: abc)"
timeout 1 ./$SCRIPT -s hashes.txt -l 1 -a abc > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 2 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 64 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2 (ALPHABET: uty)"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 -a uty > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 5 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 512 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3 (ALPHABET: abc)"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 -a abc > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 6 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 4"
timeout 5 ./$SCRIPT -s hashes.txt -l 4 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 1026 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 4 (ALPHABET: abcd)"
timeout 5 ./$SCRIPT -s hashes.txt -l 4 -a abcd > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 7 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2 (CORES: 2)"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 64 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3 (CORES: 2)"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 512 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 4 (CORES: 2)"
timeout 5 ./$SCRIPT -s hashes.txt -l 4 -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 1026 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 1 (PREFIX: a)"
timeout 1 ./$SCRIPT -s hashes.txt -l 1 -p a > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 3 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 1 (PREFIX: 1, CORES: 2)"
timeout 1 ./$SCRIPT -s hashes.txt -l 1 -p a -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 3 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2 (PREFIX: a)"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 -p a > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 46 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 2 (PREFIX: a, CORES: 2)"
timeout 1 ./$SCRIPT -s hashes.txt -l 2 -p a -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 46 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3 (PREFIX: a)"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 -p a > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 69 ]; then
    error "Failure"
else
    echo "Success"
fi

printf "   %-40s ... " "Hulk LENGTH 3 (PREFIX: a, CORES: 2)"
timeout 1 ./$SCRIPT -s hashes.txt -l 3 -p a -c 2 > $WORKSPACE/test
if [ $? -ne 0 -o $(wc -l < $WORKSPACE/test) -ne 69 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))

echo
echo "   Score $(echo "scale=2; $UNITS + ($TESTS - $FAILURES) / $TESTS.0 * 8.0" | bc)"
echo
