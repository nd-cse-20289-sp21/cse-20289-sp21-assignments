test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-reddit test-demographics

test-scripts:
	curl -sLO https://gitlab.com/nd-cse-20289-sp20/cse-20289-sp20-assignments/raw/master/homework05/test_reddit.sh
	curl -sLO https://gitlab.com/nd-cse-20289-sp20/cse-20289-sp20-assignments/raw/master/homework05/test_demographics.sh
	chmod +x test_*.sh

test-reddit:
	./test_reddit.sh

test-demographics:
	./test_demographics.sh
