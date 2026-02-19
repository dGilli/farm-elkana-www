client_host     = http://localhost:8080
playwright_host = http://localhost:8081
repo_host = https://github.com/dGilli/farm-elkana-www

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

.PHONY: no-dirty
no-dirty:
	@test -z "$(shell git status --porcelain)"

# ==================================================================================== #
# QUALITY CONTROL
# ==================================================================================== #

## audit: run quality control checks
.PHONY: audit
audit: test
	docker compose run --rm client npm audit signatures
	@echo "\033[0;31mWarning: no security audits implemented\033[0m"

## test: run all tests
.PHONY: test
test:
	docker compose up -d
	@printf "Info: waiting for client"
	@i=0; until curl -s --head ${client_host} | grep "200 OK" > /dev/null; do \
		printf "."; sleep 0.3; i=$$((i + 1)); done; printf "\n"
	docker compose exec -e PW_TEST_HTML_REPORT_OPEN=never playwright npx playwright test || true
	docker compose down

# ## test/cover: run all tests and display coverage
#.PHONY: test/cover
#test/cover:
#	@echo "Info: no test coverage implemented"

# ==================================================================================== #
# DEVELOPMENT
# ==================================================================================== #

## tidy: format project files
.PHONY: tidy
tidy: confirm no-dirty
	npx prettier -u --write

## build: build the frontend
.PHONY: build
build:
	docker compose run client sh -c "npm install --no-package-lock && npm run build"

## run: run the project
.PHONY: run
run:
	docker compose up

## run/live: run the project with reloading on file changes
.PHONY: run/live
run/live:
	docker compose up -w

# ==================================================================================== #
# OPERATIONS
# ==================================================================================== #

## open: open the project in the browser
.PHONY: open
open: playwright/open client/open

## <service>/open: open a specific <service> in the browser
.PHONY: %/open
%/open:
	xdg-open ${$*_host} 2>/dev/null || open ${$*_host}

## clean: remove all installed dependencies
.PHONY: clean
clean:
	docker compose down --rmi
	rm -rf client/node_modules client/dist

## update: update all submodules
.PHONY: update
update: client/update

## <submodule>/update: update a specific <submodule>
.PHONY: %/update
%/update:
	git submodule | grep -q $* || (echo "Error: $* is not a submodule" && exit 1)
	git add "$*"
	git commit --quiet -m "Update \`$*\` submodule to latest version"

## push: push changes to the remote Git repository
.PHONY: push
push: confirm audit no-dirty
	git push

## production/deploy: deploy the project to production
.PHONY: production/deploy
production/deploy: confirm audit no-dirty
	@echo "Info: production deploy not yet implemented"
