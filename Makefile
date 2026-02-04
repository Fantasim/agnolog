.PHONY: help install dev test lint format validate run clean build publish docs

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
	@echo "  list        List all available log types"
	@echo ""
	@echo "Documentation:"
	@echo "  docs        Show documentation location"
	@echo "  docs-open   Open docs in browser (Linux)"
	@echo ""
	@echo "Building:"
	@echo "  build       Build package"
	@echo "  clean       Remove build artifacts"
	@echo "  publish     Publish to PyPI (requires credentials)"

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

list:
	python -m agnolog --resources $(RESOURCES) --list-types

# Building
build: clean
	python -m build

clean:
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .ruff_cache/
	rm -rf htmlcov/
	rm -rf .coverage
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true

publish: build
	python -m twine upload dist/*

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
