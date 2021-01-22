BRANCH?=	$(shell git rev-parse --abbrev-ref HEAD)

test:	
	@$(MAKE) -sk test-all

test-all:	test-quiz test-code

test-quiz:
	@[ "$(BRANCH)" = "master" ] \
	    || { [ -f "$(BRANCH)/answers.json" ] && (cd $(BRANCH) && make -s test) }

test-code:
	@[ "$(BRANCH)" = "master" ] \
	    || { [ -f "$(BRANCH)/Makefile" ] && (cd $(BRANCH) && make -s test) }
