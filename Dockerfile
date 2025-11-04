# Base image
FROM node:24-alpine

# Metadata
LABEL author="NotSpartaGT" \
      maintainer="NotSpartaGT <admin@surfacerp.eu>" \
      description="NodeJS 24 Universal Alpine image for Pterodactyl with native build, media, and general tool support."

# Environment
ENV USER=container \
    HOME=/home/container \
    NODE_ENV=production

# Install basic utilities and tools
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    nano \
    unzip \
    zip \
    tar \
    gzip \
    git \
    tini \
    ffmpeg \
    iproute2 \
    bind-tools

# Install Python and build dependencies for native npm modules
RUN apk add --no-cache \
    python3 \
    py3-pip \
    make \
    g++ \
    pkgconf

# Install libraries required for canvas, sharp, and other image-related modules
RUN apk add --no-cache \
    pixman \
    pixman-dev \
    cairo-dev \
    pango-dev \
    jpeg-dev \
    giflib-dev

# Update npm to latest version and clean up cache
RUN npm install -g npm@latest && \
    npm cache clean --force

# Create container working directory
RUN mkdir -p /home/container
WORKDIR /home/container

# Copy startup scripts
COPY ./entrypoint.sh /entrypoint.sh
COPY ./start.sh /start.sh

# Make scripts executable
RUN chmod +x /entrypoint.sh /start.sh

# Default command for container
CMD ["/bin/bash", "/entrypoint.sh"]
