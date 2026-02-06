.PHONY: help install dev test lint format validate run clean build publish docs \
       release release-status release-clean sync-version build-binary build-binary-test

# Resources path (override with: make run RESOURCES=/path/to/resources)
RESOURCES ?= ./resources/mmorpg

# Default target
help:
	@echo "agnolog - Theme-agnostic Fake Log Generator"
	@echo ""
	@echo "Usage: make <target> [RESOURCES=/path/to/resources]"
	@echo ""
	@echo "Current RESOURCES: $(RESOURCES)"
	@echo ""
	@echo "Development:"
	@echo "  install     Install package in development mode"
	@echo "  dev         Install with dev dependencies"
	@echo "  test        Run all tests"
	@echo "  test-cov    Run tests with coverage report"
	@echo "  lint        Run linters (ruff)"
	@echo "  format      Format code (ruff)"
	@echo "  validate    Validate YAML/Lua resources"
	@echo ""
	@echo "Running:"
	@echo "  run         Generate 100 logs (JSON)"
	@echo "  run-text    Generate 100 logs (text format)"
	@echo "  run-loghub  Generate loghub format (3 files)"
	@echo "  list        List all available log types"
	@echo "  merge-groups Show merge groups for DB schema validation"
	@echo ""
	@echo "Building:"
	@echo "  build          Build Python package"
	@echo "  build-binary   Build standalone binary (PyInstaller)"
	@echo "  build-binary-test  Build binary and verify it works"
	@echo "  clean          Remove build artifacts"
	@echo ""
	@echo "Release:"
	@echo "  release         Create release (validate + tag + push)"
	@echo "  release-status  Check GitHub Actions workflow status"
	@echo "  release-clean   Clean up failed release"
	@echo "  sync-version    Sync version from scripts/.config.json"
	@echo ""
	@echo "Documentation:"
	@echo "  docs        Show documentation location"
	@echo "  docs-open   Open docs in browser (Linux)"

# Installation
install:
	pip install -e .

dev:
	pip install -e ".[dev]"

# Testing
test:
	python -m pytest tests/ -v

test-cov:
	python -m pytest tests/ -v --cov=agnolog --cov-report=term-missing --cov-report=html

test-quick:
	python -m pytest tests/ -q

# Code quality
lint:
	ruff check agnolog tests

format:
	ruff format agnolog tests
	ruff check --fix agnolog tests

# Validation
validate:
	python -m agnolog --resources $(RESOURCES) validate

# Running
run:
	python -m agnolog --resources $(RESOURCES) -n 100 --pretty

run-text:
	python -m agnolog --resources $(RESOURCES) -n 100 -f text

run-many:
	python -m agnolog --resources $(RESOURCES) -n 1000

run-loghub:
	python -m agnolog --resources $(RESOURCES) --loghub output -n 1000
	@echo ""
	@echo "Generated files:"
	@ls -la output.log output_structured.csv output_templates.csv

list:
	python -m agnolog --resources $(RESOURCES) --list-types

merge-groups:
	python -m agnolog --resources $(RESOURCES) --show-merge-groups

# Building
build: clean
	python -m build

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf release/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .ruff_cache/
	rm -rf htmlcov/
	rm -rf .coverage
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true

publish: build
	python -m twine upload dist/*

# Binary building (PyInstaller)
build-binary:
	pip install pyinstaller
	pyinstaller agnolog.spec
	@echo ""
	@echo "Binary built: dist/agnolog"

build-binary-test: build-binary
	@echo ""
	@echo "Verifying binary..."
	./dist/agnolog --theme mmorpg --list-types
	@echo ""
	./dist/agnolog --theme mmorpg -n 10 -f text
	@echo ""
	@echo "Binary verification passed!"

# Release
release:
	@bash scripts/release.sh

release-status:
	@bash scripts/release-status.sh

release-clean:
	@bash scripts/release-clean.sh

sync-version:
	@VERSION=$$(jq -r '.version' scripts/.config.json) && \
	sed -i "s/^version = .*/version = \"$$VERSION\"/" pyproject.toml && \
	sed -i "s/^VERSION: Final\[str\] = .*/VERSION: Final[str] = \"$$VERSION\"/" agnolog/core/constants.py && \
	echo "Synced version to $$VERSION in pyproject.toml and constants.py"

# Documentation
docs:
	@echo "Documentation available in docs/"
	@echo ""
	@echo "Available guides:"
	@ls -1 docs/*.md 2>/dev/null | sed 's|docs/||' | sed 's|^|  - |'

docs-open:
	@if command -v xdg-open > /dev/null; then \
		xdg-open docs/adding-resources.md; \
	elif command -v open > /dev/null; then \
		open docs/adding-resources.md; \
	else \
		echo "Open docs/adding-resources.md in your editor"; \
	fi

# Development workflow
check: lint test validate
	@echo "All checks passed!"
