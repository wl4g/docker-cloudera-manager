# cloudera-manager-server

## Building

```bash
cd cm-server

#docker build --target cm_base -t wl4g/cloudera-manager-server:6.3.1 .
#docker build --target cm-server -t wl4g/cloudera-manager-server:6.3.1 .

docker build -t wl4g/cloudera-manager-server:6.3.1 .
```

## Quick Start

- Cloudera Manager requires an external mysql or postgresql database, pass it as a volume and mount to `/etc/cloudera-scm-server/db.properties`

```bash
sudo mkdir -p /etc/cloudera-scm-server/

## Extract default configuration.
docker run --rm \
--entrypoint /bin/sh wl4g/docker-cloudera-manager:6.3.1 \
-c "cat /etc/cloudera-scm-server/db.properties" > /etc/cloudera-scm-server/db.properties

## Run container.
docker run -d \
--name cm-server1 \
-v /etc/cloudera-scm-server/db.properties:/etc/cloudera-scm-server/db.properties \
wl4g/docker-cloudera-manager:6.3.1
```
