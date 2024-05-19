CURRENT_DIR = .
DEV_DC = docker compose -f $(CURRENT_DIR)/docker-compose.yml

# Extract the second argument from MAKECMDGOALS, defaulting to "stable"
PROFILE ?= $(word 2,$(MAKECMDGOALS))
PROFILE := $(if $(PROFILE),$(PROFILE),stable)

build:
	$(DEV_DC) --profile $(PROFILE) build --no-cache

build-start-log: build
	$(DEV_DC) --profile $(PROFILE) up --remove-orphans

build-start: build
	$(DEV_DC) --profile $(PROFILE) up --remove-orphans -d

start:
	$(DEV_DC) --profile $(PROFILE) up --remove-orphans -d

stop:
	$(DEV_DC) --profile $(PROFILE) down

%:
	@:

.PHONY: build start build-start build-start-log