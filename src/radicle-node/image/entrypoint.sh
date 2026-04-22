#!/bin/sh
set -eu

# Ensure we run as seed
if [ "$(id -u)" = "0" ]; then
    exec su seed -s /bin/sh -c "$0 $*"
fi

# Start radicle-httpd with the same flags as systemd unit
/usr/local/bin/radicle-httpd \
  --listen 0.0.0.0:8080 &
HTTPD_PID=$!

# If httpd exits, kill node
trap 'kill $HTTPD_PID 2>/dev/null || true' INT TERM EXIT

# Start rad node in foreground (becomes PID 1 via exec)
exec "$@"