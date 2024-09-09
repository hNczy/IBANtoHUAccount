.DEFAULT_GOAL := run_all

USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
export DOCKER_USER := ${USER_ID}:${GROUP_ID}

CURRENT_DIR := $(shell pwd)
STYLE_CHECK_IGNORE := $(shell paste -sd, phpcs_ignore.txt)

run_all: run_phpunit_tests run_stylecheck

run_phpunit_tests: run_phpunit_test_php55 \
				   run_phpunit_test_php56 \
				   run_phpunit_test_php70 \
				   run_phpunit_test_php71 \
				   run_phpunit_test_php72 \
				   run_phpunit_test_php73 \
				   run_phpunit_test_php74 \
				   run_phpunit_test_php80 \
				   run_phpunit_test_php81 \
				   run_phpunit_test_php82 \
				   run_phpunit_test_php83

run_phpunit_test_php55:
	rm -rf reports/php55
	mkdir -p reports/php55
	docker compose run --rm phpunit-php55 --configuration phpunit4-5-6.xml

run_phpunit_test_php56:
	rm -rf reports/php56
	mkdir -p reports/php56
	docker compose run --rm phpunit-php56 --configuration phpunit4-5-6.xml

run_phpunit_test_php70:
	rm -rf reports/php70
	mkdir -p reports/php70
	docker compose run --rm phpunit-php70 --configuration phpunit4-5-6.xml

run_phpunit_test_php71:
	rm -rf reports/php71
	mkdir -p reports/php71
	docker compose run --rm phpunit-php71 --configuration phpunit7-8.xml

run_phpunit_test_php72:
	rm -rf reports/php72
	mkdir -p reports/php72
	docker compose run --rm phpunit-php72 --configuration phpunit7-8.xml

run_phpunit_test_php73:
	rm -rf reports/php73
	mkdir -p reports/php73
	docker compose run --rm phpunit-php73 --configuration phpunit9.xml

run_phpunit_test_php74:
	rm -rf reports/php74
	mkdir -p reports/php74
	docker compose run --rm phpunit-php74 --configuration phpunit9.xml

run_phpunit_test_php80:
	rm -rf reports/php80
	mkdir -p reports/php80
	docker compose run --rm phpunit-php80 --configuration phpunit9.xml

run_phpunit_test_php81:
	rm -rf reports/php81
	mkdir -p reports/php81
	docker compose run --rm phpunit-php81 --configuration phpunit10-11.xml

run_phpunit_test_php82:
	rm -rf reports/php82
	mkdir -p reports/php82
	docker compose run --rm phpunit-php82 --configuration phpunit10-11.xml

run_phpunit_test_php83:
	rm -rf reports/php83
	mkdir -p reports/php83
	docker compose run --rm phpunit-php83 --configuration phpunit10-11.xml

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

build: build_php55 \
	   build_php56 \
	   build_php70 \
	   build_php71 \
	   build_php72 \
	   build_php73 \
	   build_php74 \
	   build_php80 \
	   build_php81 \
	   build_php82 \
	   build_php83

build_php55:
	docker compose build phpunit-php55

build_php56:
	docker compose build phpunit-php56

build_php70:
	docker compose build phpunit-php70

build_php71:
	docker compose build phpunit-php71

build_php72:
	docker compose build phpunit-php72

build_php73:
	docker compose build phpunit-php73

build_php74:
	docker compose build phpunit-php74

build_php80:
	docker compose build phpunit-php80

build_php81:
	docker compose build phpunit-php81

build_php82:
	docker compose build phpunit-php82

build_php83:
	docker compose build phpunit-php83
