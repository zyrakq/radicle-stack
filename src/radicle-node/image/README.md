# Radicle Node Custom Image

Custom Docker image for Raux with dynamic configuration generation based on environment variables.

## Quick Start

Build the custom Radicle Node image:

```bash
cd src/radicle-node/image
docker build -t radicle-node .
docker tag radicle-node localhost/radicle-node
```
