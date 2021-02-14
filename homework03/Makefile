test:
	@$(MAKE) -sk test-all

test-all:	test-scripts test-weather test-zipcode

test-scripts:
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework03/test_weather.sh
	curl -sLO https://raw.githubusercontent.com/nd-cse-20289-sp21/cse-20289-sp21-assignments/master/homework03/test_zipcode.sh
	chmod +x test_*.sh

test-weather:
	./test_weather.sh

test-zipcode:
	./test_zipcode.sh
