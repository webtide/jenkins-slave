.PHONY: build

build:
	time docker build -t jettyproject/autobahn-testsuite:latest .

publish: build
	docker push jettyproject/autobahn-testsuite:latest

list:
	docker images jettyproject/autobahn-testsuite:*