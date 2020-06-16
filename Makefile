.PHONY: electron-vue electron-builder

HOST ?= 0.0.0.0
PORT ?= 8080

# Set project variables
PROJECT := electron-ui
GITHUB_REPO := electron-ui
GITHUB_CORP := dockerian

# set to one of example options: ng, react, vue
JSF ?= electron-vue
# prerequisite tool set
SYSTOOLS := find grep jq node npm rm sort tee xargs zip
# set to docker/host hybrid script
MAKE_RUN := tools/run.sh
# set coverage report
COVERAGE := $(JSF)/coverage
COVERAGE_REPORT := $(JSF)/coverage/lcov-report/index.html
# set debug mode
DEBUG ?= 1


.PHONY: list
list:
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | \
	awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | \
	sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs


default: check-tools clean-cache

check-tools:
	@echo ""
	@echo "--- Checking for presence of required tools: $(SYSTOOLS)"
	$(foreach tool,$(SYSTOOLS),\
	$(if $(shell which $(tool)),$(echo "boo"),\
	$(error "ERROR: Cannot find '$(tool)' in system $$PATH")))
	@echo ""
	@echo "- DONE: $@"

# clean targets
clean-cache clean:
	@echo ""
	@echo "-----------------------------------------------------------------------"
	@echo "Cleaning build ..."
	find . -name '.DS_Store' -type f -delete
	find . -name \*.bak -type f -delete
	find . -name \*.log -type f -delete
	find . -name \*.out -type f -delete
	@echo ""
	@echo "Cleaning up root packages ..."
	rm -rf .cache
	rm -rf node_modules
	rm -rf package-lock.json
	rm -rf package.json
	@echo ""
	@echo "- DONE: $@"

clean-all: clean-cache
	@echo ""
	@echo ""
	@echo "Cleaning up test coverage data ..."
	find . -name coverage -type d -prune -exec rm -rf {} +
	rm -rf $(JSF)/coverage || true
	rm -rf $(JSF)/tests/e2e/screenshots || true
	rm -rf $(JSF)/tests/e2e/videos || true
	rm -rf $(COVERAGE)
	@echo ""
	@echo "Cleaning up node_modules ..."
	find . -name node_modules -type d | xargs rm -rf
	npm cache clean --force || true
	@echo ""
	@echo "Cleaning up dist ..."
	find . -name dist -type d | xargs rm -rf
	rm -rf $(JSF)/dist || true
	rm -rf vue/dist || true
	rm -rf react/dist || true
	rm -rf ng/dist || true
	@echo ""
	@echo "- DONE: $@"

cloc:
ifeq ("$(shell which cloc 2>/dev/null)", "")   # cloc is NOT installed
	@echo ""
	@echo "Install cloc ..."
	npm install -g cloc
	@echo ""
endif
	( cd $(JSF); echo ''; cloc --exclude-dir=reports,node_modules,dist,coverage * )
	@echo ""

# default targets
build:
	@echo ""
	@echo "Run build ..."
	cd "$(JSF)" && npm run build
	@echo ""
	@echo "- DONE: $@"

install i:
	( cd $(JSF); npm install )

lint:
	( cd $(JSF); npm run lint )

audit:
	( cd $(JSF) && npm audit )

audit-fix:
	( cd $(JSF) && npm audit fix)

ncu:
	( cd $(JSF) && ncu )

ncuu:
	( cd $(JSF) && ncu -u )

serve start run:
	@echo ""
	@echo "Run start/serve ..."
	cd "$(JSF)" && npm run serve
	@echo ""
	@echo "- DONE: $@"

start-dev run-dev dev:
	( cd $(JSF) && npm run dev )

start-prod run-prod prod:
	( cd $(JSF) && npm run prod )

# testing targets
qt: lint
	( cd $(JSF); npm run unit )

e2e:
	@echo ""
	@echo "Run e2e tests ..."
	cd "$(JSF)" && npm run e2e
	@echo ""
	@echo "- DONE: $@"

unit-tests unit-test unit:
	@echo ""
	@echo "Run unit tests ..."
	cd "$(JSF)" && npm run unit
	@echo ""
	@echo "- DONE: $@"

test:
	@echo ""
	@echo "Run test ..."
	cd "$(JSF)" && npm test
	@echo ""
	@echo "- DONE: $@"

test-coverage cover: test show
	@echo ""
	@echo "- DONE: $@"

show:
	@echo ""
	@echo "--- Opening $(COVERAGE_REPORT)"
ifeq ($(OS), Windows_NT) # Windows
	start "$(COVERAGE_REPORT)"
else ifeq ($(shell uname),Darwin) # Mac OS
	open "$(COVERAGE_REPORT)"
else
	nohup xdg-open "$(COVERAGE_REPORT)" >/dev/null 2>&1 &
endif
	@echo ""
	@echo "- DONE: $@"
