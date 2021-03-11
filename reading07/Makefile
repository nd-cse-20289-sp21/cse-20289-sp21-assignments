test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-evens_fp test-evens_lc test-evens_gr

test-scripts:
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/reading07/test_evens.sh
	chmod +x test_evens.sh

test-evens_fp:
	./test_evens.sh evens_fp.py

test-evens_lc:
	./test_evens.sh evens_lc.py

test-evens_gr:
	./test_evens.sh evens_gr.py
