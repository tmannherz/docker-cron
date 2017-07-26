# docker-cron

An image to run a scheduled cron task on an existing, running container. The host's Docker socket must be mounted to the cron container when run so it can connect to the other, running container using `docker exec`.

## Environment Variables

* `CONTAINER` - Name of running Docker container where cron command will be executed
* `CRON_SCHEDULE` - Cron schedule, ie `0 * * * *`
* `CRON_COMMAND` - Command to run

## Run

```
docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e CRON_SCHEDULE="*/5 * * * *" \
    -e CRON_COMMAND="sh /my/script.sh" \
    -e CONTAINER=app \
    tmannherz/docker-cron
```

## Use with `docker-compose`

```$yaml
services:
  app:
    container_name: app
    ...

  cron:
    image: tmannherz/docker-cron
    depends_on:
      - app
    restart: always
    environment:
      CONTAINER: app
      CRON_SCHEDULE: "*/5 * * * *"
      CRON_COMMAND: "sh /my/script.sh"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro   
```
