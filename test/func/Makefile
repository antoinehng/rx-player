SHELL := /bin/bash
MOCHA ?= node "../../node_modules/.bin/mocha"
XUNIT_PREFIX := test-output
XUNIT_POSTFIX := xml

ORIGIN ?= ./

DEBUG ?= false

ifeq ($(DEBUG), false)
	MOCHA_PARAMS := $(MOCHA) -R xunit-file
	TEST_TARGETS := pre_mock_x mocha post_mock_x
	DISPLAY := :99
else
	MOCHA_PARAMS := $(MOCHA)
	TEST_TARGETS := mocha
	DISPLAY := :0
endif

CHROME_STABLE ?= $(ORIGIN)/chrome-stable/
CHROME_BETA ?= $(ORIGIN)/chrome-beta/
CHROME_UNSTABLE ?= $(ORIGIN)/chrome-unstable/
CHROME_BIN ?= opt/google/

CHROME_BINARIES ?= $(CHROME_STABLE)$(CHROME_BIN)-stable:$(CHROME_BETA)$(CHROME_BIN)-beta:$(CHROME_UNSTABLE)$(CHROME_BIN)-unstable
CHROMEDRIVER_PATH ?= $(ORIGIN)/chrome/driver

FF_STABLE ?= $(ORIGIN)/firefox/stable/
FF_BETA ?= $(ORIGIN)/firefox/beta/
FF_UNSTABLE ?= $(ORIGIN)/firefox/unstable/
FF_BIN ?= firefox/firefox

FIREFOX_BINARIES ?= $(FF_STABLE)$(FF_BIN):$(FF_BETA)$(FF_BIN):$(FF_UNSTABLE)$(FF_BIN)
FFDRIVER_PATH ?= $(ORIGIN)/firefox/driver

PATH := $(FFDRIVER_PATH):$(CHROMEDRIVER_PATH):$(PATH)

.DEFAULT_GOAL := help

chrome_pre: ## Prepare chrome directories before running tests
	@mkdir -p $(CHROMEDRIVER_PATH)
	@mkdir -p $(CHROME_STABLE) $(CHROME_BETA) $(CHROME_UNSTABLE)

firefox_pre: ## Prepare firefox directories before running tests
	@mkdir -p $(FFDRIVER_PATH)
	@mkdir -p $(FF_STABLE) $(FF_BETA) $(FF_UNSTABLE)

pre_mock_x:
	@if [ `ps -elf | grep 'Xvfb $(DISPLAY) -ac' | wc -l` -le 3 ]; then \
		Xvfb $(DISPLAY) -ac& \
	fi

post_mock_x:
	@kill -s SIGINT `ps -elf | grep "Xvfb $(DISPLAY) -ac" | grep -v "grep" | awk '{ print $$4 }'`

check_config:
	@if [[ ( ! -f "$(FF_STABLE)$(FF_BIN)" ) || ( ! -f "$(FF_BETA)$(FF_BIN)" ) || ( ! -f "$(FF_UNSTABLE)$(FF_BIN)" ) || ( ! -f "$(FFDRIVER_PATH)/wires" ) ]]; then \
		printf "\nPlease run firefox_pre before launching tests, and check the README to install the right binaries\n\n\n" && exit 1; \
  fi
	@if [[ ( ! -f "$(CHROME_STABLE)$(CHROME_BIN)-stable" ) || ( ! -f "$(CHROME_BETA)$(CHROME_BIN)-beta" ) || ( ! -f "$(CHROME_UNSTABLE)$(CHROME_BIN)-unstable" ) || ( ! -f "$(CHROMEDRIVER_PATH)/chromedriver" ) ]]; then \
		printf "\nPlease run chrome_pre before launching tests, and check the README to install the right binaries\n\n\n" && exit 1; \
  fi

test: check_config $(TEST_TARGETS) ## Launch Functionnal Testing. See README.md before running

help: ## Display this message.
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

mocha:
	@-XUNIT_PREFIX=$(XUNIT_PREFIX) XUNIT_POSTFIX=$(XUNIT_POSTFIX) CHR_BIN_TMP=$(CHROME_BINARIES) FF_BIN_TMP=$(FIREFOX_BINARIES) DEBUG=$(DEBUG) PATH=$(PATH) DISPLAY=$(DISPLAY) MOCHA_PARAMS="$(MOCHA_PARAMS)" ./launch_tests.sh

clean:
	@rm -Rf $(ORIGIN)/chrome $(ORIGIN)/firefox

.PHONY: help test clean
