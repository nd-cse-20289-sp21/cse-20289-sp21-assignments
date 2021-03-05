#!/bin/bash

WORKSPACE=/tmp/reading06.$(id -u)
FAILURES=0

# Functions

error() {
    echo "$1"
    echo
    [ -r $WORKSPACE/test ] && cat $WORKSPACE/test
    echo
    FAILURES=$((FAILURES + $2))
}

cleanup() {
    STATUS=${1:-$FAILURES}
    rm -fr $WORKSPACE
    exit $STATUS
}

courses_sh() {
    curl -sL https://yld.me/djNR \
    	| grep -Eo 'CSE [234][0-9]{4}' \
    	| sed -E -e 's/CSE 2.*/Sophomore/' -e 's/CSE 3.*/Junior/' -e 's/CSE 4.*/Senior/' \
    	| sort | uniq -c | sort -rn
}

users_sh() {
    cat /etc/passwd | cut -d : -f 5 | sed '/^\s*$/d' | env LC_ALL=C sort
}

machines_sh() {
    curl -sL http://catalog.cse.nd.edu:9097/query.json | sed -En 's/\{"name":"([^"]+)".*"type":"wq_factory".*/\1/p'
}

# Main Execution

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

echo "Testing scripts..."

printf " %-40s ... " "courses.py"
diff -u <(./courses.py) <(courses_sh) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure" 2
else
    echo "Success"
fi

printf " %-40s ... " "users.py"
diff -u <(./users.py) <(users_sh) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure" 1
else
    echo "Success"
fi

printf " %-40s ... " "machines.py"
diff -u <(./machines.py) <(machines_sh) &> $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure" 1
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))
echo
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 4.0" | bc | awk '{printf "%0.2f\n", $1}')"
echo
