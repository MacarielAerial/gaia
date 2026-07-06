# syntax=docker/dockerfile:1.7

# Global Build Arguments
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# =========================
# Multi Stage: Dev
# =========================
FROM python:3.14-slim AS dev

# Arguments associated with the non-root user
ARG USERNAME
ARG USER_UID
ARG USER_GID

# Set environemntal variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_SYSTEM_PYTHON=1 \
    RUSTUP_HOME=/opt/rustup \
    CARGO_HOME=/opt/cargo

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    pkg-config \
    ca-certificates \
    git \
    git-lfs \
    just \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --default-toolchain stable --profile minimal

# Global just-lsp install
RUN /opt/cargo/bin/cargo install just-lsp --locked --root /usr/local

# Install uv
COPY --from=ghcr.io/astral-sh/uv:0.11.26 /uv /uvx /usr/local/bin/

# Add the non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Switch to the non-root user to install applications on the user level
USER ${USERNAME}

# Check uv is installed
RUN uv --version

# Install template render dependencies
RUN uv tool install copier
