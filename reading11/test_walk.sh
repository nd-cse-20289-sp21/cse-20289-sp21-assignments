#!/bin/bash

WORKSPACE=/tmp/walk.$(id -u)
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

walk_py() {
    python3 - $1 <<EOF
import os
import sys

root = sys.argv[1] if len(sys.argv) > 1 else '.'

for name in os.listdir(root):
    path = os.path.join(root, name)
    if os.path.isfile(path) and not os.path.islink(path):
        print(name, os.path.getsize(path))
EOF
}

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

echo
echo "Testing walk ..."

printf " %-40s ... " "walk (no arguments)"
./walk | sort | diff -y - <(walk_py | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "walk ."
./walk | sort | diff -y - <(walk_py . | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "walk .."
./walk .. | sort | diff -y - <(walk_py .. | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "walk ~"
./walk ~ | sort | diff -y - <(walk_py ~ | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "walk /etc"
./walk /etc | sort | diff -y - <(walk_py /etc | sort) > $WORKSPACE/test
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo "Success"
fi

printf " %-40s ... " "walk asdf"
./walk asdf &> $WORKSPACE/test
if [ $? -eq 0 ] || ! grep -q 'No such file or directory' $WORKSPACE/test; then
    error "Failure"
else
    echo "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))
echo "   Score $(echo "scale=2; ($TESTS - $FAILURES) / $TESTS.0 * 2.0" | bc | awk '{printf "%0.2f\n", $0}')"
echo
