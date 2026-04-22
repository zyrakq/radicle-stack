FROM debian:trixie-slim

ARG RADICLE_ALIAS="seed.radicle.example"

# BuildKit/Buildx automatically provides these 
ARG TARGETOS
ARG TARGETARCH

USER root

# Initial necessities

RUN apt update \
    && apt install -y \
    curl git xz-utils tini

# Download and install radicle: https://radicle.xyz/download

## download radicle keys
RUN curl -LO https://radicle.xyz/apt/radicle-archive-keyring.deb \
    && chmod a+r radicle-archive-keyring.deb \
    && apt install ./radicle-archive-keyring.deb

## add keys to sources
RUN echo "deb [signed-by=/usr/share/radicle/radicle-archive-keyring.asc] https://radicle.xyz/apt release main" | tee -a  "/etc/apt/sources.list"

## retrieve new repos and install radicle
RUN apt update \
    && apt install -y radicle

# User and group setup: https://radicle.xyz/guides/seeder
RUN groupadd --system seed \
    && useradd --system --gid seed --create-home seed

# Rad HTTPd setup
WORKDIR /tmp/

# ## download 
# RUN curl -O -L https://files.radicle.xyz/releases/radicle-httpd/latest/radicle-httpd-$TARGETARCH.tar.xz \
#     && tar -xvJf  radicle-httpd-$TARGETARCH.tar.xz --strip-components=1 -C /usr/local/ \
#     && chown seed:seed /usr/local/radicle-httpd

# Compute Radicle's $TARGET triple from Docker's TARGETOS/TARGETARCH
# (Adjust if you need other OS/arches later.)
RUN set -eux; \
    case "${TARGETOS}/${TARGETARCH}" in \
    linux/amd64)  TARGET="x86_64-unknown-linux-musl" ;; \
    linux/arm64)  TARGET="aarch64-unknown-linux-musl" ;; \
    darwin/amd64) TARGET="x86_64-apple-darwin" ;; \
    darwin/arm64) TARGET="aarch64-apple-darwin" ;; \
    *) echo "Unsupported platform: ${TARGETOS}/${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    curl -O -L "https://files.radicle.xyz/releases/radicle-httpd/latest/radicle-httpd-$TARGET.tar.xz" \
    && tar -xvJf  "radicle-httpd-$TARGET.tar.xz" --strip-components=1 -C /usr/local/ \
    && chown seed:seed /usr/local/bin/radicle-httpd

## entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Rad system setup
USER seed
RUN rad auth --alias ${RADICLE_ALIAS}

## default radicle system port
EXPOSE 8776
EXPOSE 8080


ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/entrypoint.sh"]
CMD ["rad", "node", "start", "--foreground"]