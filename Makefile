ALL_GO_MOD_DIRS := $(shell find . -type f -name 'go.mod' -exec dirname {} \; | sort)

GOTEST_MIN = go test -v -timeout 30s
GOTEST = $(GOTEST_MIN) -race
GOTEST_WITH_COVERAGE = $(GOTEST) -coverprofile=coverage.txt -covermode=atomic

TAG ?= latest
REGISTRY_ID ?= 718206584555
REPOSITORY_REGION ?= us-east-1
APP_NAME ?= goapp
ENV_NAME ?= dev
REPO_NAME = $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com/${APP_NAME}-${ENV_NAME}
GO_REPO_NAME = $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com/golang
ALPINE_REPO_NAME = $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com/alpine
ALPINE_VERSION = 3.16

.DEFAULT_GOAL := help

.PHONY: help
help: ## List of available commands
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: test-with-coverage
test-with-coverage: ## Build the go tests with coverage
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  (cd "$${dir}" && \
	    $(GOTEST_WITH_COVERAGE) ./... && \
	    go tool cover -html=coverage.txt -o coverage.html); \
	done

.PHONY: go-build
go-build: ## Build the go source
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  (cd "$${dir}" && \
	    go build ./... && \
	    go test -run xxxxxMatchNothingxxxxx ./... >/dev/null); \
	done

.PHONY: build-images
build-images: ## Build the Docker images
	$(info Make: Building...)
	@TAG=$(TAG) docker-compose build --no-cache

.PHONY: up
up: ## Run containers and print logs in stdout
	$(info Make: Starting containers...)
	@TAG=$(TAG) docker-compose up -d
	@make -s logs

.PHONY: down
down: ## Stop containers
	$(info Make: Stopping containers...)
	@TAG=$(TAG) docker-compose down

.PHONY: logs
logs: ## Print logs in stdout
	@TAG=$(TAG) docker-compose logs -f api

.PHONY: test
test: ## Run go tests
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  (cd "$${dir}" && \
	    $(GOTEST) ./...); \
	done

.PHONY: lint
lint: ## Run the go linter
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  (cd "$${dir}" && \
	    golangci-lint run -E goimports); \
	done

.PHONY: tidy
tidy: ## Run go mod tidy
	set -e; for dir in $(ALL_GO_MOD_DIRS); do \
	  (cd "$${dir}" && \
	    go mod tidy); \
	done

.PHONY: ci
ci: test tidy

.PHONY: push-ecr
push-ecr: ## Push image to ecr 
	$(MAKE) docker-login
	docker build -t $(REPO_NAME):$(TAG) -f ./Dockerfile .
	docker push $(REPO_NAME):$(TAG)

.PHONY: docker-login
docker-login: ## Login to ecr
	aws ecr get-login-password --region $(REPOSITORY_REGION) | docker login --username AWS --password-stdin $(REGISTRY_ID).dkr.ecr.$(REPOSITORY_REGION).amazonaws.com

.PHONY: push-go-ecr
push-go-ecr: ## Push golang image to ecr 
	$(MAKE) docker-login
	docker tag golang:1.17.11-alpine$(ALPINE_VERSION) $(GO_REPO_NAME):1.17.11-alpine$(ALPINE_VERSION)
	docker push $(GO_REPO_NAME):1.17.11-alpine$(ALPINE_VERSION)

.PHONY: push-alpine-ecr
push-alpine-ecr: ## Push alpine image to ecr 
	$(MAKE) docker-login
	docker tag alpine:$(ALPINE_VERSION) $(ALPINE_REPO_NAME):$(ALPINE_VERSION)
	docker push $(ALPINE_REPO_NAME):$(ALPINE_VERSION)	

.PHONY: push-init-images
push-init-images: push-go-ecr push-alpine-ecr push-ecr