test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-filters

test-scripts:
	curl -sLO https://github.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/raw/master/reading03/test_filters.sh
	chmod +x test_filters.sh

test-filters:
	./test_filters.sh
