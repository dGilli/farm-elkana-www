PROJECT_NAME := farm-elkana-www
APP_DIR := client
LINK_FILES := package.json \
		 	  package-lock.json \
		      vite.config.ts \
		      public \
		      src/content \
			  wrangler.jsonc \
			  worker \
			  .wrangler

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
.PHONY: help
help:
	@printf 'A edge-deployed Cloudflare Worker that wraps an AI built frontend application.\n$(PROJECT_NAME) command line interface.\n\n'
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | awk '/^$$/{print "~"; next} /:./{print "  " $$0; next} {sub(/^ /,""); print "~"; print}' | column -t -s ':' | sed 's/^~.*//'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

.PHONY: no-dirty
no-dirty:
	@test -z "$(shell git status --porcelain)"

# ==================================================================================== #
## QUALITY CONTROL
# ==================================================================================== #

## audit: run quality control checks (unimplemented!)
.PHONY: audit
audit: #test
	@$(foreach d,$(APP_DIR) tests,echo "Auditing $(d):";npm --prefix $(d) audit; npm --prefix $(d) audit signatures;)

## test: run all tests
.PHONY: test
test:
	npm --prefix tests install
	npx --prefix tests playwright install
	BASE_URL=http://localhost:8787 npx --prefix tests playwright test

## test/cover: run all tests and display coverage (unimplemented!)
.PHONY: test/cover
test/cover:
	echo "unimplemented!"

# ==================================================================================== #
## DEVELOPMENT
# ==================================================================================== #

## clean: clean installed dependencies and build artifacts
.PHONY: clean
clean: confirm
	rm -r client/node_modules client/dist

## build: build the application
.PHONY: build
build:
	npm --prefix $(APP_DIR) run build

## run: run the application
.PHONY: run
run: update
	npm --prefix $(APP_DIR) run dev

## run: preview the built application
.PHONY: preview
preview:
	npm --prefix $(APP_DIR) run preview

# ==================================================================================== #
## OPERATIONS
# ==================================================================================== #

## push: push changes to the remote Git repository
.PHONY: push
push: confirm audit no-dirty
	git push

## upgrade: pull newest client code and update worker
.PHONY: upgrade
upgrade:
	@changes=$$(git -C client status --porcelain --untracked-files=no); \
	if [ -n "$$changes" ]; then \
		printf 'The following changed files will be overwritten in client:\n%s\n\n' "$$changes"; \
		$(MAKE) --no-print-directory confirm || exit 1; \
	fi; \
	git submodule update --remote --init --recursive --force
	$(MAKE) --no-print-directory update

## update: update and install worker in client
.PHONY: update
update:
	rm -rf $(APP_DIR)/src/content $(APP_DIR)/worker $(APP_DIR)/.wrangler
	@$(foreach f,$(LINK_FILES),ln -sfv $$(pwd)/$(notdir $(f)) $(APP_DIR)/$(dir $(f));)
	npm --prefix $(APP_DIR) install

## production/deploy: deploy application to production
.PHONY: production/deploy
production/deploy: confirm update audit no-dirty
	npm --prefix $(APP_DIR) run deploy

