CC=             gcc
CFLAGS=         -g -Wall -std=gnu99
TARGETS=        walk

all:            $(TARGETS)

# TODO: Add rule for walk

test:
	        @$(MAKE) -sk test-all

test-all:	test-walk

test-walk:	walk
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/reading11/test_walk.sh
	chmod +x test_walk.sh
	./test_walk.sh

clean:
	rm -f $(TARGETS)

.SUFFIXES:
