CC=             gcc
CFLAGS=         -g -Wall -std=gnu99
TARGETS=        sort grep

all:            $(TARGETS)

# TODO: Add rules for sort and grep

test:
	        @$(MAKE) -sk test-all

test-all:	test-sort test-grep

test-sort:	sort
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/reading09/test_sort.sh
	chmod +x test_sort.sh
	./test_sort.sh

test-grep:	grep
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/reading09/test_grep.sh
	chmod +x test_grep.sh
	./test_grep.sh

clean:
	rm -f $(TARGETS)

.SUFFIXES:
