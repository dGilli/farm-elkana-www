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
# DEVELOPMENT
# ==================================================================================== #

## dev: run project for local development
.PHONY: dev
dev:
	cd client && npm run dev

## clean: remove all installed dependencies
.PHONY: clean
clean:
	rm -rf client/node_modules client/dist

## client/build: build the frontend
.PHONY: client/build
client/build:
	cd client && npm install --no-package-lock && npm run build

## build: build all
.PHONY: build
build: client/build

# ==================================================================================== #
# OPERATIONS
# ==================================================================================== #

## <submodule>/update: update a 'submodule' or use 'all'
.PHONY: %update
%/update:
	@if [ "$*" = "all" ]; then \
		echo "Updating all submodules..."; \
		git submodule update --recursive --remote && \
		git commit -m "update all submodules to latest version"; \
	else \
		git submodule | grep -q $* || (echo "Error: Submodule '$*' does not exist in the repository." && exit 1) && \
		echo "Updating '$*' submodule..."; \
		git add "$*" && \
		git commit -m "Update \`$*\` submodule to latest version"; \
	fi

## push: push changes to the remote Git repository
.PHONY: push
push: confirm audit no-dirty
	git push

