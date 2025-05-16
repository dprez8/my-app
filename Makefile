# Makefile
SVC_NAME = mc
APP_VSN := $(shell grep 'version:' mix.exs | cut -d '"' -f2)

.PHONY: help
help: ## Print targets and help
	@echo "Service: $(SVC_NAME):$(APP_VSN)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: dev
dev:	## Levanta la app en modo desarrollo -> http://localhost:4003
	docker-compose --env-file secret.env up -d
	@arg=$(filter-out $@,$(MAKECMDGOALS)); \
	if [ -z "$$arg" ]; then \
		echo "Starting Application at http://localhost:4003"; \
		export MC_HOST_PORT=4003; \
		$(shell grep -v '^#' secret.env | sed 's/^/export /'); \
		iex --sname my_node_4003@localhost -S mix phx.server; \
	else \
		echo "Starting Application at http://localhost:$$arg"; \
		export MC_HOST_PORT=$$arg; \
		$(shell grep -v '^#' secret.env | sed 's/^/export /'); \
		iex --sname my_node_$${arg}@localhost -S mix phx.server; \
	fi

.PHONY: down
down: ## Detiene la app
	docker-compose down -v