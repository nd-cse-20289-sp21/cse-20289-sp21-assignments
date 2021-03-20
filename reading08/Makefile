test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-translations

test-scripts:
	curl -sLO 
	chmod +x test_translations.sh

test-translations:
	./test_translations.sh

