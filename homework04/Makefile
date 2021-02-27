test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-rpn test-unique

test-scripts:
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework04/test_rpn.sh
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework04/test_unique.sh
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework04/unique_test.py
	chmod +x test_*.sh *_test.py

test-rpn:
	./test_rpn.sh

test-unique:
	./test_unique.sh
