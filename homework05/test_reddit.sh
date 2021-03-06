#!/bin/bash

# Configuration

SCRIPT=reddit.py
WORKSPACE=/tmp/$SCRIPT.$(id -u)
FAILURES=0

export PYTHONIOENCODING=utf-8 # Work around Unicode Shenanigans on GitLab-CI

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

las_test() {
    ./$SCRIPT linuxactionshow > $WORKSPACE/output || return 1
    [ $(wc -l < $WORKSPACE/output) -eq 29 ] || return 1
    grep -q Matrix $WORKSPACE/output || return 1
    grep -q LAS $WORKSPACE/output || return 1
    grep -q FCC $WORKSPACE/output || return 1
}

las_test_limit() {
    ./$SCRIPT -n 1 linuxactionshow | sed -E 's/Score: [0-9]+/Score: 0/' > $WORKSPACE/output || return 1
    [ $(wc -l < $WORKSPACE/output) -eq 2 ] || return 1
    diff -y $WORKSPACE/output <(las_test_limit_output) > $WORKSPACE/log
}

las_test_limit_output() {
    cat <<EOF
   1.	Matrix.org | An open network for secure, decentralized commu (Score: 0)
	https://matrix.org/
EOF
}

las_test_orderby() {
    ./$SCRIPT -o url linuxactionshow > $WORKSPACE/output || return 1
    [ $(wc -l < $WORKSPACE/output) -eq 29 ] || return 1
    [ "$(cat $WORKSPACE/output | head -n 2 | tail -n 1 | sed -E 's/^[ \t]+//')" = "http://101.opensuse.org/" ]
}

las_test_titlelen() {
    ./$SCRIPT -t 10 linuxactionshow > $WORKSPACE/output || return 1
    [ $(wc -l < $WORKSPACE/output) -eq 29 ] || return 1
    [ "$(cat $WORKSPACE/output | grep -v http | wc -c)" -eq 303 ]
}

las_test_shorten() {
    ./$SCRIPT -s linuxactionshow > $WORKSPACE/output || return 1
    [ $(wc -l < $WORKSPACE/output) -eq 29 ] || return 1
    grep -q 'yCjytQ' $WORKSPACE/output || return 1
    grep -q 'jNJAHF' $WORKSPACE/output || return 1
    grep -q 'VClyLU' $WORKSPACE/output || return 1
}

void_output() {
    cat <<EOF
   1.	VoidLinux.eu Is Not Ours (Score: 36)
	https://voidlinux.org/news/2019/02/voidlinux-eu-gone.html

   2.	Ok, that was awesome, the installation was easy, i like runi (Score: 33)
	https://i.redd.it/2678tali7sf21.png

   3.	Great job on Voidlinux (Score: 26)
	https://www.reddit.com/r/voidlinux/comments/ap4vlf/great_job_on_voidlinux/

   4.	KVM Virtualization with virt-manager on Void Linux (Score: 12)
	https://www.daveeddy.com/2019/02/11/kvm-virtualization-with-virtmanager-on-void-linux/

   5.	When and why did you start using Void? (Score: 6)
	https://www.reddit.com/r/voidlinux/comments/aq2cid/when_and_why_did_you_start_using_void/

   6.	Void Wiki Contributions (Score: 6)
	https://www.reddit.com/r/voidlinux/comments/apq8p5/void_wiki_contributions/

   7.	Problems with startx and startxfce4 (Score: 6)
	https://www.reddit.com/r/voidlinux/comments/apej53/problems_with_startx_and_startxfce4/

   8.	why isn't my root partition or swap marked as a swap/ext4 (Score: 6)
	https://i.redd.it/wk2l2jikhuf21.jpg

   9.	how can i fix that font problem? sorry, but i'm a newbie (Score: 4)
	https://i.redd.it/e70f1i1eodg21.jpg

  10.	libstdc++.so.6 and Steam - I already installed all additiona (Score: 4)
	https://www.reddit.com/r/voidlinux/comments/aps3fo/libstdcso6_and_steam_i_already_installed_all/
EOF
}

void_limit_output() {
    cat <<EOF
   1.	VoidLinux.eu Is Not Ours (Score: 36)
	https://voidlinux.org/news/2019/02/voidlinux-eu-gone.html

   2.	Ok, that was awesome, the installation was easy, i like runi (Score: 33)
	https://i.redd.it/2678tali7sf21.png

   3.	Great job on Voidlinux (Score: 26)
	https://www.reddit.com/r/voidlinux/comments/ap4vlf/great_job_on_voidlinux/

   4.	KVM Virtualization with virt-manager on Void Linux (Score: 12)
	https://www.daveeddy.com/2019/02/11/kvm-virtualization-with-virtmanager-on-void-linux/

   5.	When and why did you start using Void? (Score: 6)
	https://www.reddit.com/r/voidlinux/comments/aq2cid/when_and_why_did_you_start_using_void/
EOF
}

void_limit_orderby_output() {
    cat <<EOF
   1.	CPU core high utilization after running any Love2D project m (Score: 2)
	https://old.reddit.com/r/love2d/comments/apjtnw/cpu_core_high_utilization_after_running_any/

   2.	Can't wake from zzz (Score: 3)
	https://www.reddit.com/r/voidlinux/comments/aqagq7/cant_wake_from_zzz/

   3.	Great job on Voidlinux (Score: 26)
	https://www.reddit.com/r/voidlinux/comments/ap4vlf/great_job_on_voidlinux/

   4.	How to interact with volume? (Score: 1)
	https://www.reddit.com/r/voidlinux/comments/apw5f9/how_to_interact_with_volume/

   5.	How to setup wifi after a minimal Void install? (Score: 4)
	https://www.reddit.com/r/voidlinux/comments/apcs0f/how_to_setup_wifi_after_a_minimal_void_install/
EOF
}

void_limit_orderby_titlelen_output() {
    cat <<EOF
   1.	Ok, that was awesome (Score: 33)
	https://i.redd.it/2678tali7sf21.png

   2.	how can i fix that f (Score: 4)
	https://i.redd.it/e70f1i1eodg21.jpg

   3.	why isn't my root pa (Score: 6)
	https://i.redd.it/wk2l2jikhuf21.jpg

   4.	CPU core high utiliz (Score: 2)
	https://old.reddit.com/r/love2d/comments/apjtnw/cpu_core_high_utilization_after_running_any/

   5.	VoidLinux.eu Is Not  (Score: 36)
	https://voidlinux.org/news/2019/02/voidlinux-eu-gone.html
EOF
}

void_limit_orderby_titlelen_shorten_output() {
    cat <<EOF
   1.	VoidLinux.eu Is Not Ours (Score: 36)
	https://is.gd/4MsSx1

   2.	Ok, that was awesome, the installation w (Score: 33)
	https://is.gd/VC3zel
EOF
}

# Setup

mkdir $WORKSPACE

trap "cleanup" EXIT
trap "cleanup 1" INT TERM

# Tests

echo "Testing $SCRIPT ..."

printf "   %-40s ... " "Doctests"
grep -q '>>> load_reddit_data' $SCRIPT
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
./$SCRIPT 2>&1 | grep -i usage &> /dev/null
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi


printf "   %-40s ... " "linuxactionshow"
if ! las_test; then
    error "Failure"
else
    echo  "Success"
fi

rm -f $WORKSPACE/log
printf "   %-40s ... " "linuxactionshow (-n 1)"
if ! las_test_limit ; then
    [ ! -r $WORKSPACE/log ] || mv $WORKSPACE/output $WORKSPACE/log
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "linuxactionshow (-o url)"
if ! las_test_orderby ; then
    mv $WORKSPACE/output $WORKSPACE/log
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "linuxactionshow (-t 10)"
if ! las_test_titlelen ; then
    mv $WORKSPACE/output $WORKSPACE/log
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "linuxactionshow (-s)"
if ! las_test_shorten ; then
    mv $WORKSPACE/output $WORKSPACE/log
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "voidlinux"
diff -y <(./$SCRIPT https://yld.me/raw/qZH) <(void_output) > $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "voidlinux (-n 5)"
diff -y <(./$SCRIPT -n 5 https://yld.me/raw/qZH) <(void_limit_output) > $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "voidlinux (-n 5 -o title)"
diff -y <(./$SCRIPT -n 5 -o title https://yld.me/raw/qZH) <(void_limit_orderby_output) > $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "voidlinux (-n 5 -o url -t 20)"
diff -y <(./$SCRIPT -n 5 -o url -t 20 https://yld.me/raw/qZH) <(void_limit_orderby_titlelen_output) > $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

printf "   %-40s ... " "voidlinux (-n 2 -o score -t 40 -s)"
diff -y <(./$SCRIPT -n 2 -o score -t 40 -s https://yld.me/raw/qZH) <(void_limit_orderby_titlelen_shorten_output) > $WORKSPACE/log
if [ $? -ne 0 ]; then
    error "Failure"
else
    echo  "Success"
fi

TESTS=$(($(grep -c Success $0) - 1))

echo
echo "   Score $(echo "scale=2; $UNITS + ($TESTS - $FAILURES) / $TESTS.0 * 4.0" | bc | awk '{printf "%0.2f\n", $1}')"
echo
