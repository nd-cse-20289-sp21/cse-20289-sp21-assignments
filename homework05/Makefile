test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-reddit test-demographics

test-scripts:
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework05/test_demographics.sh
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework05/test_reddit.sh
	chmod +x test_*.sh

test-reddit:
	./test_reddit.sh

test-demographics:
	./test_demographics.sh
