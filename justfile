set dotenv-load := true
set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
  @just --list

# Install dependencies (dev included)
install:
  uv sync --dev

# Lint pipeline
lint:
  uv run ruff check . --fix --show-fixes
  uv run ruff format .
  uv run mypy .
  uv run yamllint .
  find . -type f \( -name "*.sh" -o -name "*.bash" \) -not -path "./_rendered/*" -print0 | xargs -0r shellcheck

# Run tests with coverage
test:
  uv run pytest --cov={{{{ package_name }}}} --cov-report=term-missing

# Run the app locally
run:
  uv run uvicorn {{{{ package_name }}}}.main:app --host 0.0.0.0 --port 8000 --reload

# -------------------------
# Consumer workflow
# -------------------------

generate destination:
  copier copy . {{ destination }} --trust --vcs-ref HEAD

# -------------------------
# Template maintainer only
# -------------------------

render-ci:
  rm -rf _rendered
  copier copy . _rendered --trust --vcs-ref HEAD --defaults

render-install:
  UV_PROJECT_ENVIRONMENT="$PWD/_rendered/.venv" bash -lc 'cd _rendered && just install'

render-lint:
  UV_PROJECT_ENVIRONMENT="$PWD/_rendered/.venv" bash -lc 'cd _rendered && just lint'

render-test:
  UV_PROJECT_ENVIRONMENT="$PWD/_rendered/.venv" bash -lc 'cd _rendered && just test'

validate:
  just render-ci
  just render-install
  just render-lint
  just render-test
