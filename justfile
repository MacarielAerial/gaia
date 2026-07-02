set dotenv-load := true
set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
  @just --list

# -------------------------
# Local template development helpers
# -------------------------

generate destination:
  copier copy . {{ destination }} --trust --vcs-ref HEAD

# -------------------------
# Template maintainer only
# -------------------------

render-ci:
  rm -rf rendered
  copier copy . rendered --trust --vcs-ref HEAD --defaults

render-install:
  cd rendered && UV_PROJECT_ENVIRONMENT=".venv" just install

render-lint:
  cd rendered && CHECK_ONLY=true UV_PROJECT_ENVIRONMENT=".venv" just lint

render-test:
  cd rendered && UV_PROJECT_ENVIRONMENT=".venv" just test

validate:
  just render-ci
  just render-install
  just render-lint
  just render-test
