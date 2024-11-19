#
# Multi Stage: Dev Image
#
FROM python:3.11-slim-bookworm AS dev

# Arguments associated with the non-root user
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Set environemntal variables
ENV POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_HOME=/home/${USERNAME}/poetry \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Add poetry executable to PATH
ENV PATH="$POETRY_HOME/bin:$PATH"

# Add the non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # graphviz \
    # graphviz-dev \
    # texlive-xetex \
    # texlive-fonts-recommended \
    # texlive-plain-generic \
    # pandoc \
    # libgl1-mesa-glx \
    curl \
    git \
    git-lfs

# Install Node.JS globally for in development
# RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash - && \
#     apt-get install -y nodejs \
#     build-essential && \
#     node --version && \
#     npm --version

# Install playwright system dependencies
# RUN npm -g install playwright@1.46.0
# RUN playwright install --with-deps chromium

# Switch to the non-root user to install applications on the user level
USER ${USERNAME}

# Explicitly populate home directory variable
ENV HOME=/home/${USERNAME}

# Install poetry
RUN mkdir -p ${HOME}/poetry && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    poetry self add poetry-plugin-up

# Verify Poetry installation
RUN poetry --version

# Make available system dependency installation scripts
# COPY scripts/* /scripts/

# Install OpenTofu
# RUN /scripts/install_opentofu.sh

#
# Multi Stage: Bake Image
#

FROM python:3.11-slim-bookworm AS bake

# Set environemntal variables
ENV POETRY_VIRTUALENVS_IN_PROJECT=1 \
    POETRY_HOME=/home/poetry \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Add poetry executable to PATH
ENV PATH="$POETRY_HOME/bin:$PATH"

# Install curl
RUN apt-get update && apt-get install -y \
    curl

# Install poetry
RUN mkdir -p /home/poetry && \
    curl -sSL https://install.python-poetry.org | python3 - && \
    poetry self add poetry-plugin-up

# Verify Poetry installation
RUN poetry --version

# Make working directory
RUN mkdir -p /app

# Copy source code and python dependency specification
COPY pyproject.toml poetry.lock README.md /app/
COPY src /app/src

# Set working directory
WORKDIR /app

# Install python dependencies in container
RUN poetry install --without dev

#
# Multi Stage: Runtime Image
#

# Local python is preferred but this image
# has complete system dependencies
FROM python:3.11-slim-bookworm AS runtime

# Copy over baked environment
# Explicitly copy the otherwise ignore .venv folder
COPY --from=bake /app /app
COPY --from=bake /app/.venv /app/.venv

# Set 
WORKDIR /app

# Set executables in PATH
ENV PATH="/app/.venv/bin:$PATH"

# Expose the service port
EXPOSE 80

# TODO: Add a command to start the service
# ENTRYPOINT ["fastapi", "run", "app/src/main.py", "--port", "80"]
