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
  UV_PROJECT_ENVIRONMENT="$PWD/rendered/.venv" bash -lc 'cd rendered && just install'

render-lint:
  UV_PROJECT_ENVIRONMENT="$PWD/rendered/.venv" bash -lc 'cd rendered && just lint'

render-test:
  UV_PROJECT_ENVIRONMENT="$PWD/rendered/.venv" bash -lc 'cd rendered && just test'

validate:
  just render-ci
  just render-install
  just render-lint
  just render-test
