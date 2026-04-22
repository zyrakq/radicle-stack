# Radicle Explorer Custom Image

Custom Docker image for Raux with dynamic configuration generation based on environment variables.

## Quick Start

Build the custom Radicle Explorer image:

```bash
cd src/radicle-explorer/image
docker build -t radicle-explorer .
docker tag radicle-explorer localhost/radicle-explorer
```
