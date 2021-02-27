test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-rpn test-unique

test-scripts:
	curl -sLO https://gitlab.com/nd-cse-20289-sp20/cse-20289-sp20-assignments/raw/master/homework04/test_rpn.sh
	curl -sLO https://gitlab.com/nd-cse-20289-sp20/cse-20289-sp20-assignments/raw/master/homework04/test_unique.sh
	curl -sLO https://gitlab.com/nd-cse-20289-sp20/cse-20289-sp20-assignments/raw/master/homework04/unique_test.py
	chmod +x test_*.sh *_test.py

test-rpn:
	./test_rpn.sh

test-unique:
	./test_unique.sh
