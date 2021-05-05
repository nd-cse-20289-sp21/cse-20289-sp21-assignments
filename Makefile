BRANCH?=	$(shell git rev-parse --abbrev-ref HEAD)

test:	
	@$(MAKE) -sk test-all

test-all:	test-quiz test-code

test-quiz:
	@[ "$(BRANCH)" = "master" -o -z "$(BRANCH)" ] \
	    || [ ! -f "$(BRANCH)/answers.json" -a ! -f "$(BRANCH)/answers.yaml" ] \
	    || .scripts/check.py \

test-code:
	@[ "$(BRANCH)" = "master" -o -z "$(BRANCH)" ] \
	    || [ ! -f "$(BRANCH)/Makefile" ] \
	    || (cd $(BRANCH) && make -s test)
