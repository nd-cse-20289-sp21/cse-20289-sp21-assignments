#!/bin/bash

WORKSPACE=/tmp/str_title.$(id -u)
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
echo "Testing str_title ..."

printf " %-40s ... " "str_title (no arguments)"
./str_title | diff -y - <(true) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title (no arguments) (valgrind)"
valgrind --leak-check=full ./str_title &> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title  harry potter"
./str_title harry potter| diff -y - <(printf "Harry\nPotter\n") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title  harry potter  (valgrind)"
valgrind --leak-check=full ./str_title harry potter &> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title 'harry potter'"
./str_title 'harry potter'| diff -y - <(printf "Harry Potter\n") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title 'harry potter' (valgrind)"
valgrind --leak-check=full ./str_title 'harry potter' &> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title  a b c d"
./str_title a b c d| diff -y - <(printf "A\nB\nC\nD\n") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title  a b c d  (valgrind)"
valgrind --leak-check=full ./str_title a b c d&> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title 'a b c d'"
./str_title 'a b c d'| diff -y - <(printf "A B C D\n") > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "str_title 'a b c d' (valgrind)"
valgrind --leak-check=full ./str_title 'a b c d' &> $WORKSPACE/test
if [ $? -ne 0 ] || [ "$(awk '/ERROR SUMMARY/ {print $4}' $WORKSPACE/test)" -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 2.0" | bc | awk '{printf "%0.2f\n", $0}')"
echo
