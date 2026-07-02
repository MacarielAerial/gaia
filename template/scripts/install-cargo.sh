#!/usr/bin/env bash
set -euo pipefail

# Use the officla installer
curl https://sh.rustup.rs -sSf | sh -s -- -y --profile minimal

# Check to see if it's available
cargo --version
