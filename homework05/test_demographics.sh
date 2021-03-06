#!/bin/bash

# Configuration

SCRIPT=demographics.py
WORKSPACE=/tmp/$SCRIPT.$(id -u)
FAILURES=0

# Functions

error() {
    echo "$@"
    [ -r $WORKSPACE/log ] && cat $WORKSPACE/log
    FAILURES=$((FAILURES + 1))
}

cleanup() {
    STATUS=${1:-$FAILURES}
    rm -fr $WORKSPACE
    exit $STATUS
}

default_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023
================================================================================================
   M      49      44      58      60      65     101      96      92      89     120     121
   F      14      12      16      19      26      45      54      43      46      35      47
------------------------------------------------------------------------------------------------
   B       3       2       4       1       5       3       3       4       6       4       1
   C      43      43      47      53      60     107      96      92      87     100      96
   N       1       1       1       7       5       5      13      14      13      13      20
   O       7       5       9       9      12      10      13       7       8      12      11
   S       7       4      10       9       3      13      10      10      11      16      27
   T       2       1       1       0       6       8      15       7       9       6      11
   U       0       0       2       0       0       0       0       1       1       1       2
------------------------------------------------------------------------------------------------
EOF
}

default_y2013_output() {
    cat <<EOF
        2013
================
   M      49
   F      14
----------------
   B       3
   C      43
   N       1
   O       7
   S       7
   T       2
   U       0
----------------
EOF
}

default_y2023_output() {
    cat <<EOF
        2023
================
   M     121
   F      47
----------------
   B       1
   C      96
   N      20
   O      11
   S      27
   T      11
   U       2
----------------
EOF
}

default_y2017_2019_2021_output() {
    cat <<EOF
        2017    2019    2021
================================
   M      65      96      89
   F      26      54      46
--------------------------------
   B       5       3       6
   C      60      96      87
   N       5      13      13
   O      12      13       8
   S       3      10      11
   T       6      15       9
   U       0       0       1
--------------------------------
EOF
}

default_p_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023
================================================================================================
   M   77.8%   78.6%   78.4%   75.9%   71.4%   69.2%   64.0%   68.1%   65.9%   77.4%   72.0%
   F   22.2%   21.4%   21.6%   24.1%   28.6%   30.8%   36.0%   31.9%   34.1%   22.6%   28.0%
------------------------------------------------------------------------------------------------
   B    4.8%    3.6%    5.4%    1.3%    5.5%    2.1%    2.0%    3.0%    4.4%    2.6%    0.6%
   C   68.3%   76.8%   63.5%   67.1%   65.9%   73.3%   64.0%   68.1%   64.4%   64.5%   57.1%
   N    1.6%    1.8%    1.4%    8.9%    5.5%    3.4%    8.7%   10.4%    9.6%    8.4%   11.9%
   O   11.1%    8.9%   12.2%   11.4%   13.2%    6.8%    8.7%    5.2%    5.9%    7.7%    6.5%
   S   11.1%    7.1%   13.5%   11.4%    3.3%    8.9%    6.7%    7.4%    8.1%   10.3%   16.1%
   T    3.2%    1.8%    1.4%    0.0%    6.6%    5.5%   10.0%    5.2%    6.7%    3.9%    6.5%
   U    0.0%    0.0%    2.7%    0.0%    0.0%    0.0%    0.0%    0.7%    0.7%    0.6%    1.2%
------------------------------------------------------------------------------------------------
EOF
}

default_G_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023
================================================================================================
   B       3       2       4       1       5       3       3       4       6       4       1
   C      43      43      47      53      60     107      96      92      87     100      96
   N       1       1       1       7       5       5      13      14      13      13      20
   O       7       5       9       9      12      10      13       7       8      12      11
   S       7       4      10       9       3      13      10      10      11      16      27
   T       2       1       1       0       6       8      15       7       9       6      11
   U       0       0       2       0       0       0       0       1       1       1       2
------------------------------------------------------------------------------------------------
EOF
}

default_E_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019    2020    2021    2022    2023
================================================================================================
   M      49      44      58      60      65     101      96      92      89     120     121
   F      14      12      16      19      26      45      54      43      46      35      47
------------------------------------------------------------------------------------------------
EOF
}

equality_output() {
    cat <<EOF
        2013    2014    2015    2016    2017    2018    2019
================================================================
   M       1       1       1       1       1       1       1
   F       1       1       1       1       1       1       1
----------------------------------------------------------------
   B       2       0       0       0       0       0       0
   C       0       2       0       0       0       0       0
   N       0       0       2       0       0       0       0
   O       0       0       0       2       0       0       0
   S       0       0       0       0       2       0       0
   T       0       0       0       0       0       2       0
   U       0       0       0       0       0       0       2
----------------------------------------------------------------
EOF
}

equality_y2016_p_output() {
    cat <<EOF
        2016
================
   M   50.0%
   F   50.0%
----------------
   B    0.0%
   C    0.0%
   N    0.0%
   O  100.0%
   S    0.0%
   T    0.0%
   U    0.0%
----------------
EOF
}

equality_y2016_p_E_output() {
    cat <<EOF
        2016
================
   M   50.0%
   F   50.0%
----------------
EOF
}

equality_y2016_p_E_G_output() {
    cat <<EOF
        2016
================
EOF
}

# Setup

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

# Tests

echo "Testing $SCRIPT ..."

printf "   %-40s ... " "Doctests"
grep -q '>>> load_demo_data' $SCRIPT
if [ $? -ne 0 ]; then                                                  
    UNITS=0
    echo "MISSING"
else
    python3 -m doctest -v $SCRIPT 2> /dev/null > $WORKSPACE/test
    TOTAL=$(grep 'tests.*items' $WORKSPACE/test | awk '{print $1}')
    PASSED=$(grep 'passed.*failed' $WORKSPACE/test | awk '{print $1}')
    UNITS=$(echo "scale=2; ($PASSED / $TOTAL) * 1.0" | bc)
    echo "$UNITS / 1.00"
fi

printf "   %-40s ... " "Bad arguments"
./$SCRIPT -bad &> /dev/null
if [ $? -eq 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "-h"
./$SCRIPT -h 2>&1 | grep -i usage &> /dev/null
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "No arguments"
diff -y <(./$SCRIPT) <(default_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "bWhu"
diff -y <(./$SCRIPT https://yld.me/raw/bWhu) <(default_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "bWhu -y 2013"
diff -y <(./$SCRIPT -y 2013) <(default_y2013_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "bWhu -y 2023"
diff -y <(./$SCRIPT -y 2023) <(default_y2023_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "bWhu -y 2017,2021,2019"
diff -y <(./$SCRIPT -y 2017,2021,2019) <(default_y2017_2019_2021_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "bWhu -p"
diff -y <(./$SCRIPT -p) <(default_p_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "bWhu -G"
diff -y <(./$SCRIPT -G) <(default_G_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "bWhu -E"
diff -y <(./$SCRIPT -E) <(default_E_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "ilG"
diff -y <(./$SCRIPT https://yld.me/raw/ilG) <(equality_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "ilG -y 2016 -p"
diff -y <(./$SCRIPT -y 2016 -p https://yld.me/raw/ilG) <(equality_y2016_p_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "ilG -y 2016 -p -E"
diff -y <(./$SCRIPT -y 2016 -p -E https://yld.me/raw/ilG) <(equality_y2016_p_E_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "ilG -y 2016 -p -E -G"
diff -y <(./$SCRIPT -y 2016 -p -E -G https://yld.me/raw/ilG) <(equality_y2016_p_E_G_output) &> $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))

echo
echo "   Score $(echo "scale=2; $UNITS + ($TESTS - $FAILURES) / $TESTS.0 * 6.0" | bc | awk '{printf "%0.2f\n", $1}')"
echo
