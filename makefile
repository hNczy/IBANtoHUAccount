.DEFAULT_GOAL := run_all

USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
export DOCKER_USER := ${USER_ID}:${GROUP_ID}

CURRENT_DIR := $(shell pwd)
STYLE_CHECK_IGNORE := $(shell paste -sd, phpcs_ignore.txt)

run_all: run_phpunit_tests run_stylecheck

run_phpunit_tests: run_phpunit_test_php55 run_phpunit_test_php56 run_phpunit_test_php70 run_phpunit_test_php71

run_phpunit_test_php55:
	rm -rf reports/php55
	mkdir -p reports/php55
	docker-compose run --rm phpunit-php55

run_phpunit_test_php56:
	rm -rf reports/php56
	mkdir -p reports/php56
	docker-compose run --rm phpunit-php56

run_phpunit_test_php70:
	rm -rf reports/php70
	mkdir -p reports/php70
	docker-compose run --rm phpunit-php70

run_phpunit_test_php71:
	rm -rf reports/php71
	mkdir -p reports/php71
	docker-compose run --rm phpunit-php71

run_stylecheck:
	rm -rf reports/style
	mkdir -p reports/style
	docker run --rm \
		--user ${DOCKER_USER} \
		--volume ${CURRENT_DIR}:/code \
		ghcr.io/hasznaltauto/coding-standards-php:latest \
		phpcs -p \
			--ignore="${STYLE_CHECK_IGNORE}" \
			--basepath=/code \
			--report-file=/code/reports/style/checkstyle.xml \
			--runtime-set ignore_errors_on_exit 1 \
			--runtime-set ignore_warnings_on_exit 1 \
			--report=checkstyle /code

build: build_php55 build_php56 build_php70 build_php71

build_php55:
	docker-compose build phpunit-php55

build_php56:
	docker-compose build phpunit-php56

build_php70:
	docker-compose build phpunit-php70

build_php71:
	docker-compose build phpunit-php71
