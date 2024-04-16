FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04 as base

ARG GROUP

RUN apt update && apt install -y curl gcc software-properties-common make pkg-config
RUN add-apt-repository ppa:deadsnakes/ppa
#RUN apt update && apt install -y python3.12

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python && \
    cd /usr/local/bin && \
    ln -s /opt/poetry/bin/poetry && \
    poetry config virtualenvs.create false
COPY pyproject.toml pyproject.toml

FROM base as main
RUN poetry install --without dev

# for docker-compose in local development
FROM base as local
RUN apt install -y netcat-openbsd
RUN poetry install
