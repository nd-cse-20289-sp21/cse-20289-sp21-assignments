#!/bin/bash

PROGRAM=doit
WORKSPACE=/tmp/$PROGRAM.$(id -u)
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

echo "Testing $PROGRAM ..."

printf " %-60s ... " "$PROGRAM (syscalls)"
if ! grep -q fork $PROGRAM.c || ! grep -q exec $PROGRAM.c || ! grep -q wait $PROGRAM.c; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM (usage)"
if ! ./$PROGRAM |& grep -q -i usage; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM true (status)"
if ! ./$PROGRAM true &> $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM true (valgrind)"
valgrind --leak-check=full ./$PROGRAM true &> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {errors += $4} END {print errors}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM false (status)"
if ./$PROGRAM false &> $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM false (valgrind)"
valgrind --leak-check=full ./$PROGRAM false &> $WORKSPACE/test
if [ $? -eq 0 ] || [ "$(awk '/ERROR SUMMARY/ {errors += $4} END {print errors}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM NOPE (status)"
if ./$PROGRAM NOPE &> $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM NOPE (valgrind)"
valgrind --leak-check=full ./$PROGRAM NOPE &> $WORKSPACE/test
if [ $? -eq 0 ] || [ "$(awk '/ERROR SUMMARY/ {errors += $4} END {print errors}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM ls (output)"
./$PROGRAM ls | diff - -y <(ls) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM ls (status)"
if ! ./$PROGRAM ls &> $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM ls (valgrind)"
valgrind --leak-check=full ./$PROGRAM ls &> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {errors += $4} END {print errors}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM 'echo execution of all things' (output)"
./$PROGRAM 'echo execution of all things' | diff - -y <(echo execution of all things) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM 'echo execution of all things' (status)"
if ! ./$PROGRAM 'echo execution of all things' &> $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi

printf " %-60s ... " "$PROGRAM 'echo execution of all things' (valgrind)"
valgrind --leak-check=full ./$PROGRAM 'echo execution of all things' &> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {errors += $4} END {print errors}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 3.0" | bc | awk '{printf "%0.2f\n", $0}')"
echo
