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
