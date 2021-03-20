test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-translations

test-scripts:
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/reading08/test_translations.sh
	chmod +x test_translations.sh

test-translations:
	./test_translations.sh

