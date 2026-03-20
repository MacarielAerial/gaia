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
    UV_SYSTEM_PYTHON=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    git \
    git-lfs \
    just \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Add the non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Switch to the non-root user to install applications on the user level
USER ${USERNAME}

# Explicitly populate home directory variable
ENV HOME=/home/${USERNAME}

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Make sure uv is reachable by the user shell
ENV PATH="${HOME}/.local/bin:${PATH}"

# Check uv is installed
RUN uv --version

# Install template render dependencies
RUN uv tool install copier
