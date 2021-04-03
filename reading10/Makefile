CC=             gcc
CFLAGS=         -g -Wall -std=gnu99
TARGETS=        str_title

all:            $(TARGETS)

# TODO: Add rule for str_title

test:
	        @$(MAKE) -sk test-all

test-all:	test-str_title

test-str_title:	str_title
	curl -sLO 
	chmod +x test_str_title.sh
	./test_str_title.sh

clean:
	rm -f $(TARGETS)

.SUFFIXES:
