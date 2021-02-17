#!/bin/bash

if [ ! -r filters.sh ]; then
    echo 'Missing filters.sh!'
    exit 1
else
    . filters.sh
fi

# Utility

q_test() {
    exec 2> log.1

    echo -n "      Q${1} "
    if diff -y <(${2}) <(${3}) &> log.2; then
    	echo 'Success'
    	STATUS=0
    else
    	echo 'Failure'
    	cat log.1 log.2
    	STATUS=1
    fi

    rm log.1 log.2
    return $STATUS
}

# Q1

q1_output() {
    cat <<EOF
Donatello
Leonardo
Michelangelo
Raphael
EOF
}

q1_test() {
    q_test 1 q1_answer q1_output
}

# Q2

q2_output() {
    cat <<EOF
BLUE
PURPLE
RED
ORANGE
EOF
}

q2_test() {
    q_test 2 q2_answer q2_output
}

# Q3

q3_output() {
    cat <<EOF
Leonardo:blue:plowshare
Donatello:purple:plowshare
Raphael:red:plowshare
Michelangelo:orange:plowshare
EOF
}

q3_test() {
    q_test 3 q3_answer q3_output
}

# Q4

q4_output() {
    cat <<EOF
Donatello
Michelangelo
EOF
}

q4_test() {
    q_test 4 q4_answer q4_output
}

# Q5

q5_output() {
    cat <<EOF
Leonardo
Raphael
EOF
}

q5_test() {
    q_test 5 q5_answer q5_output
}

# Q6

q6_output() {
    cat <<EOF
3
EOF
}

q6_test() {
    q_test 6 q6_answer q6_output
}

# Q7

q7_output() {
    cat <<EOF
Leonardo
Donatello
EOF
}

q7_test() {
    q_test 7 q7_answer q7_output
}

# Q8

q8_output() {
    cat <<EOF
purple
EOF
}

q8_test() {
    q_test 8 q8_answer q8_output
}

# Main execution

SCORE=0

echo "Testing filters.sh ..."
q1_test && SCORE=$((SCORE + 1))
q2_test && SCORE=$((SCORE + 1))
q3_test && SCORE=$((SCORE + 1))
q4_test && SCORE=$((SCORE + 1))
q5_test && SCORE=$((SCORE + 1))
q6_test && SCORE=$((SCORE + 1))
q7_test && SCORE=$((SCORE + 1))
q8_test && SCORE=$((SCORE + 1))

echo "   Score $(echo "scale=2; $SCORE / 8.0 * 1.0" | bc | awk '{printf "%0.2f\n", $1}')"
exit $(($SCORE - 8))
