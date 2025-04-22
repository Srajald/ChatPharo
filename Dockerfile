ARG OLLAMA_VERSION=latest
FROM ollama/ollama:${OLLAMA_VERSION} AS ollama

FROM ollama AS base
RUN apt-get update && apt-get install -y \
    curl wget unzip gnupg lsb-release ca-certificates \
    libcairo2 libc6 libfreetype6 libssl3 fuse \
 && rm -rf /var/lib/apt/lists/*

# Install Pharo
RUN curl -L https://get.pharo.org/64 | bash \
 && mv pharo /usr/local/bin/pharo \
 && mv pharo-vm /usr/local/bin/pharo-vm \
 && mkdir -p /var/pharo/images/default \
 && mv Pharo.image /var/pharo/images/default/Pharo.image \
 && mv Pharo.changes /var/pharo/images/default/Pharo.changes

FROM base AS builder
ARG MODEL_NAME
ARG MODEL_TAG
WORKDIR /model

# Start Ollama and pull model
RUN ollama serve & \
    until curl -s http://localhost:11434; do \
        echo "Waiting for Ollama to be ready..."; \
        sleep 5; \
    done && \
    ollama pull ${MODEL_NAME}:${MODEL_TAG}

FROM base

COPY --from=builder /root/.ollama /root/.ollama
WORKDIR /var/pharo/images/default

# Expose Ollama API
EXPOSE 11434

# Start Ollama server and run Pharo as default CMD
CMD /root/.ollama/bin/ollama serve & \
    /usr/local/bin/pharo /var/pharo/images/default/Pharo.image