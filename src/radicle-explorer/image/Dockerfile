# ---- build stage ----
FROM node:20-bookworm-slim AS build

RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone live explorer source
RUN git clone https://github.com/radicle-dev/radicle-explorer.git .

# Optional: checkout a specific commit or tag for reproducibility
# RUN git checkout vX.Y.Z

RUN npm ci

# Enable runtime config
ENV VITE_RUNTIME_CONFIG=true
RUN npm run build

# ---- runtime stage ----
FROM nginx:1.31-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]