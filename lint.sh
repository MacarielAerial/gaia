#!/bin/bash -e

echo "Shell checking..."
shellcheck ./**.sh

echo "Linting YAML..."
yamllint . --strict

echo "Sorting Python import definitions..."
if [[ "${CI:=}" == "true" ]]; then
  isort . --check-only --diff
else
  isort .
fi

echo "Applying opinionated Python code style..."
if [[ "${CI:=}" == "true" ]]; then
  black . --check --diff
else
  black .
fi

echo "Checking PEP8 compliance..."
flake8 .

echo "Running Ruff checker..."
if [[ "${CI:=}" == "true" ]]; then
  ruff check src
  ruff check tests
else
  ruff check src
  ruff check tests
fi

echo "Checking Python types..."
mypy src
mypy tests
