.PHONY: help push lab01 lab02 lab03 lab04 build serve clean

TODAY := $(shell date +"%m-%d")

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

push: ## pushes changes to git
	git add -A
	git commit -m "update repo $(TODAY)" --allow-empty
	git pull origin main
	git push origin main

lab: ## starts jupyterlab
	uv run jupyter lab

lab01: ## lab01
	rm -rf labs/lab01
	uv run otter assign --no-run-tests src/lab01/lab01.ipynb .otter-build
	mkdir -p labs/lab01
	mv .otter-build/student/* labs/lab01/
	rm -rf .otter-build labs/lab01/tests

lab03: ## lab03
	uv run otter assign --no-run-tests src/lab03/lab03.ipynb .otter-build
	mkdir -p labs/lab03
	mv .otter-build/student/* labs/lab03/
	rm -rf .otter-build labs/lab03/tests

lab04: ## lab04
	uv run otter assign --no-run-tests src/lab04/lab04.ipynb .otter-build
	mkdir -p labs/lab04
	mv .otter-build/student/* labs/lab04/
	rm -rf .otter-build labs/lab04/tests

build: ## Build the JupyterLite site for in-browser notebooks
	uv sync
	uv run jupyter lite build --contents labs --output-dir dist

serve: ## Serve the built JupyterLite site locally
	cd dist && uv run jupyter lite serve --port 8000

clean: ## Remove the JupyterLite build directory
	rm -rf dist
