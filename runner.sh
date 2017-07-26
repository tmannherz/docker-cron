#!/bin/sh
set -e
docker exec $CONTAINER $CRON_COMMAND
echo "$(date +%Y-%m-%dT%H:%M:%SZ)"": Task complete"
