#!/bin/bash
set -e

if [ -z "$CRON_SCHEDULE" ]; then
    echo "CRON_SCHEDULE must be specified."
    exit 1
fi
if [ -z "$CRON_COMMAND" ]; then
    echo "CRON_COMMAND must be specified."
    exit 1
fi
if [ -z "$CONTAINER" ]; then
    echo "CONTAINER must be specified."
    exit 1
fi

mkdir -p /etc/cron.d
TASK=/etc/cron.d/task
touch $TASK
chmod 0644 $TASK

COMMAND="$CRON_SCHEDULE root /runner.sh >> /var/log/cron.log 2>&1"
echo "$COMMAND" > $TASK
echo "# End" >> $TASK

if [ "$1" == "" ]; then
    # Expose env vars to the cron
    env | sed -r "s/'/\\\'/gm" | sed -r "s/^([^=]+=)(.*)\$/\1'\2'/gm" > /etc/environment
    echo "Starting the cron service against $CONTAINER ($CRON_SCHEDULE $CRON_COMMAND)."
    cron -f
fi

exec "$@"
