SRC = $(shell find src  -name "*.js" -type f | sort)
TST = $(shell find test -name "*.js" -type f | sort)
SRC_IDX = src/index.js
TST_IDX = test/index.js
BUNDLE_STD ?= node "node_modules/webpack/bin/webpack.js" --progress
BUNDLE_DEV ?= node "node_modules/webpack-dev-server/bin/webpack-dev-server.js" --port 9999 --progress

dist/one-player-core.js: $(SRC_IDX) $(SRC)
	@$(BUNDLE_STD) $< $@

dist/one-player-core.min.js: $(SRC_IDX) $(SRC)
	@CP_PROD=true $(BUNDLE_STD) $< dist/one-player-core.tmp.js
	@closure-compiler --language_in=ECMASCRIPT5 --compilation_level SIMPLE_OPTIMIZATIONS --js dist/one-player-core.tmp.js > $@
	@rm dist/one-player-core.tmp.js

all: dist/one-player-core.js dist/one-player-core.min.js

build: dist/one-player-core.js

min: dist/one-player-core.min.js

clean:
	@rm -f dist/one-player-core.js
	@rm -f dist/one-player-core.min.js

update-version:
	@./bin/update-version

release: lint update-version all
	@./bin/release

lint:
	@eslint $(SRC)

dev: $(SRC_IDX) $(SRC)
	@$(BUNDLE_STD) -w $< dist/one-player-core.js

demo:
	@$(BUNDLE_STD) --config webpack-demo.config.js -w

test: $(TST_IDX) $(SRC) $(TST)
	@CP_NODE_PROCESS=true $(BUNDLE_DEV) --quiet --content-base test/ "mocha!$<" --output-file test.js

.PHONY: all build min clean release lint test demo
