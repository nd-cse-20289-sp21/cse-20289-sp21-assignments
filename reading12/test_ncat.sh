#!/bin/bash

PROGRAM=ncat
WORKSPACE=/tmp/$PROGRAM.$(id -u)
FAILURES=0

export PATH=/usr/sbin:$PATH

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


test_valgrind() {
    if [ $(awk '/ERROR SUMMARY:/ {errors += $4} END{print errors}' $WORKSPACE/test) -ne 0 ]; then
	error "Failure"
    else
	echo "Success"
    fi
}

grep_all() {
    for pattern in $1; do
    	if ! grep -q -E "$pattern" $2; then
    	    echo "Missing $pattern in $2" >> $WORKSPACE/test
    	    return 1;
    	fi
    done
    return 0;
}

nc_server() {
    PORT=""
    while [ -z "$PORT" ]; do
	PORT=$(shuf -i9000-9999 -n 1)
	if grep -q $PORT <(ss -tln | grep -Po '9\d{3}'); then
	    PORT=""
	fi
    done

    { nc -l -p $PORT &> $WORKSPACE/test || nc -l $PORT &> $WORKSPACE/test; } &
    SPID=$!
}

# Setup

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

# Tests

echo "Testing $PROGRAM ..."

printf " %-60s ... " "$PROGRAM (syscalls)"
PATTERNS="socket getaddrinfo connect close"
if ! grep_all "$PATTERNS" $PROGRAM.c; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM (usage, output)"
PATTERN="usage"
valgrind --leak-check=full ./$PROGRAM &> $WORKSPACE/test
if [ $? -eq 0 ] || ! grep -q "$PATTERN" $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi
printf " %-60s ... " "$PROGRAM (usage, valgrind)" && test_valgrind

printf " %-60s ... " "$PROGRAM (fakehost 9999, client)"
MESSAGE=$(md5sum <<<$(whoami) | awk '{print $1}')
PATTERN="Name or service not known"
valgrind --leak-check=full ./$PROGRAM fakehost 9999 <<<$MESSAGE &> $WORKSPACE/test
if [ $? -eq 0 ] || ! grep -q "$PATTERN" $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi
printf " %-60s ... " "$PROGRAM (fakehost 9999, valgrind)" && test_valgrind

printf " %-60s ... " "$PROGRAM (localhost 10, client)"
MESSAGE=$(md5sum <<<$(whoami) | awk '{print $1}')
PATTERN="Connection refused"
valgrind --leak-check=full ./$PROGRAM localhost 10 <<<$MESSAGE &> $WORKSPACE/test
if [ $? -eq 0 ] || ! grep -q "$PATTERN" $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi
printf " %-60s ... " "$PROGRAM (localhost 10, valgrind)" && test_valgrind

nc_server
printf " %-60s ... " "$PROGRAM (localhost $PORT, client)"
MESSAGE=$(md5sum <<<$(whoami) | awk '{print $1}')
PATTERN="Connected"
valgrind --leak-check=full ./$PROGRAM localhost $PORT <<<$MESSAGE &>> $WORKSPACE/test
if [ $? -ne 0 ] || ! grep -q "$PATTERN" $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi
printf " %-60s ... " "$PROGRAM (localhost $PORT, server)"
wait $SPID
if [ $? -ne 0 ] || ! grep -q "$MESSAGE" $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi
printf " %-60s ... " "$PROGRAM (localhost $PORT, valgrind)" && test_valgrind

printf " %-60s ... " "$PROGRAM (weasel.h4x0r.space 9110, client)"
MESSAGE="$(whoami) $(date +%s)"
PATTERN="Connected"
valgrind --leak-check=full ./$PROGRAM weasel.h4x0r.space 9110 <<<$MESSAGE &> $WORKSPACE/test
if [ $? -ne 0 ] || ! grep -q "$PATTERN" $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi
printf " %-60s ... " "$PROGRAM (weasel.h4x0r.space 9110, server)"
if [ $? -ne 0 ] || ! curl -s http://weasel.h4x0r.space:9111 | grep -q "$MESSAGE"; then
    error "Failure"
else
    echo "Success"
fi
printf " %-60s ... " "$PROGRAM (weasel.h4x0r.space 9110, valgrind)" && test_valgrind

TESTS=$(($(grep -c Success $0) - 1 + $(grep -c test_valgrind $0) - 2))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 3.0" | bc | awk '{printf "%0.2f\n", $0}')"
echo
