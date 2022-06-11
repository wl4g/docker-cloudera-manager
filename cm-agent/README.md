# cloudera-manager-agent

## Quick start

### 1. Building

- 1.1 Preconditions

  Before building the image, you should first download and prepare the `cloudera-manager-daemons*.rpm/cloudera-manager-agent*.rpm` material installation package to `cm-agent/material/` directory.

  You can download it from the official website: [https://archive.cloudera.com/cm6/6.3.1](https://archive.cloudera.com/cm6/6.3.1), or download it from here: [https://pan.baidu.com/s/1G9WbCITyY8IHOmAsvB1osw](https://pan.baidu.com/s/1G9WbCITyY8IHOmAsvB1osw) &nbsp;&nbsp; password: &nbsp; `a4n8`

- 1.2 Docker build

```bash
cd cm-agent

## Build of segmented
#docker build --target cm_base -t wl4g/cloudera-manager-agent:6.3.1 .
#docker build --target cm-agent -t wl4g/cloudera-manager-agent:6.3.1 .

docker build -t wl4g/cloudera-manager-agent:6.3.1 .
```

### 2. Run cm-server container

> Before starting cm-agent you should start cm-server first.

- 2.1 Preconditions

```bash
sudo mkdir -p /etc/cloudera-scm-agent/
sudo mkdir -p /mnt/disk1/log/cloudera-scm-agent/
sudo mkdir -p /opt/cloudera/csd/
sudo mkdir -p /opt/cloudera/parcel-cache/
sudo mkdir -p /opt/cloudera/parcels/
sudo chmod -R 777 /etc/cloudera-scm-agent/
sudo chmod -R 777 /mnt/disk1/log/cloudera-scm-agent/
sudo chmod -R 777 /opt/cloudera/csd/
sudo chmod -R 777 /opt/cloudera/parcel-cache/
sudo chmod -R 777 /opt/cloudera/parcels/
```

- 2.2 Before starting, you should configure the cm server info you need to connect, pass it as a volume and mount to `/etc/cloudera-scm-agent/config.ini`

```bash
## Extract default configuration.
docker run --rm \
--entrypoint /bin/sh wl4g/cloudera-manager-agent:6.3.1 \
-c "cat /etc/cloudera-scm-agent/config.ini" > /etc/cloudera-scm-agent/config.ini
```

- 2.3 Run container

```bash
docker run -d \
--name cm-agent1 \
--network host \
-v /etc/cloudera-scm-agent/config.ini:/etc/cloudera-scm-agent/config.ini \
-v /mnt/disk1/log/cloudera-scm-agent/:/var/log/cloudera-scm-agent/ \
-v /opt/cloudera/csd/:/opt/cloudera/csd/ \
-v /opt/cloudera/parcel-cache/:/opt/cloudera/parcel-cache/ \
-v /opt/cloudera/parcels/:/opt/cloudera/parcels/ \
wl4g/cloudera-manager-agent:6.3.1
```
