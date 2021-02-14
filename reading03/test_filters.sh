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
    if diff -u <(${2}) <(${3}) &> log.2; then
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
ALL YOUR BASE ARE BELONG TO US
EOF
}

q1_test() {
    q_test 1 q1_answer q1_output
}

# Q2

q2_output() {
    cat <<EOF
gorillaz love bananas
EOF
}

q2_test() {
    q_test 2 q2_answer q2_output
}

# Q3

q3_output() {
    cat <<EOF
monkeys love bananas
EOF
}

q3_test() {
    q_test 3 q3_answer q3_output
}

# Q4

q4_output() {
    cat <<EOF
/bin/bash
EOF
}

q4_test() {
    q_test 4 q4_answer q4_output
}

# Q5

q5_output() {
    cat <<EOF
root:x:0:0:root:/root:/usr/bin/python
mysql:x:27:27:MySQL Server:/var/lib/mysql:/usr/bin/python
xguest:x:500:501:Guest:/home/xguest:/usr/bin/python
condor:x:108172:40:Condor Batch System:/afs/nd.edu/user37/condor:/usr/bin/python
lukew:x:522:40:Luke Westby temp access:/var/tmp/lukew:/usr/bin/python
EOF
}

q5_test() {
    q_test 5 q5_answer q5_output
}

# Q6

q6_output() {
    cat <<EOF
rtkit:x:499:497:RealtimeKit:/proc:/sbin/nologin
qpidd:x:497:495:Owner of Qpidd Daemons:/var/lib/qpidd:/sbin/nologin
uuidd:x:495:487:UUID generator helper daemon:/var/lib/libuuid:/sbin/nologin
mailnull:x:47:47::/var/spool/mqueue:/sbin/nologin
EOF
}

q6_test() {
    q_test 6 q6_answer q6_output
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

echo "   Score $(echo "scale=2; $SCORE / 4.0 * 2.0" | bc)"
exit $(($SCORE - 6))
