CC=		gcc
CFLAGS=		-g -Wall -std=gnu99
LD=		gcc
LDFLAGS=	-L.
AR=		ar
ARFLAGS=	rcs

TARGETS=	libstr.a \
		libstr.so

all:		$(TARGETS)

test:		
	@$(MAKE) -sk test-all
	
test-all:	test-libstr test-str

test-libstr:	libstr.so
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework07/test_libstr.py
	chmod +x test_libstr.py
	./test_libstr.py -v

test-str:	str-static str-dynamic
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework07/test_str.sh
	chmod +x test_str.sh
	./test_str.sh

clean:
	rm -f $(TARGETS) *.o

# TODO: Add rules for libstr.a libstr.so

# TODO: Add rules for str-dynamic str-static
