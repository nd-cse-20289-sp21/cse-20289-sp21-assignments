test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-exists

test-scripts:
	curl -sLO 
	chmod +x test_*.sh

test-exists:
	./test_exists.sh
