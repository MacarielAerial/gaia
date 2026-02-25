set dotenv-load := true
set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
  @just --list

# Install dependencies (dev included)
install:
  uv sync --dev

# Lint pipeline: format → lint → typecheck
lint:
  uv run ruff format .
  uv run ruff check .
  uv run mypy .

# Run tests
test:
  uv run pytest

# Run the app locally
run:
  uv run uvicorn {{{{ package_name }}}}.main:app --host 0.0.0.0 --port 8000 --reload

# -------------------------
# Template validation only
# -------------------------

render:
  rm -rf _rendered
  copier copy . _rendered --trust

render-install:
  uv --project _rendered sync --dev

render-lint:
  uv --project _rendered run ruff format .
  uv --project _rendered run ruff check .
  uv --project _rendered run mypy .

render-test:
  uv --project _rendered run pytest

validate:
  just render
  just render-install
  just render-lint
  just render-test
