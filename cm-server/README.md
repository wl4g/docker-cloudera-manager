# cloudera-manager-server

## 1. Building

- 1.1 Preconditions

> Before building the image, you should first download and prepare the `cloudera-manager-*.rpm` material installation package.
> You can download it from the official website: [https://archive.cloudera.com/cm6/6.3.1](https://archive.cloudera.com/cm6/6.3.1), or download it from here: [https://pan.baidu.com/s/1G9WbCITyY8IHOmAsvB1osw](https://pan.baidu.com/s/1G9WbCITyY8IHOmAsvB1osw) &nbsp;&nbsp; password: &nbsp; `a4n8`

- 1.2 Docker build

```bash
cd cm-server

## Build of segmented
#docker build --target cm_base -t wl4g/cloudera-manager-server:6.3.1 .
#docker build --target cm-server -t wl4g/cloudera-manager-server:6.3.1 .

docker build -t wl4g/cloudera-manager-server:6.3.1 .
```

## 2. Quick Start

> Follow the steps below, you need to prepare an external MySQL 5.7+ instance

- 2.1 Preconditions

```bash
sudo mkdir -p /etc/cloudera-scm-server/
sudo mkdir -p /mnt/disk1/log/cloudera-scm-server/
sudo mkdir -p /opt/cloudera/csd/
sudo mkdir -p /opt/cloudera/parcel-cache/
sudo mkdir -p /opt/cloudera/parcel-repo/
sudo mkdir -p /opt/cloudera/parcels/
sudo chmod -R 777 /etc/cloudera-scm-server/
sudo chmod -R 777 /mnt/disk1/log/cloudera-scm-server/
sudo chmod -R 777 /opt/cloudera/csd/
sudo chmod -R 777 /opt/cloudera/parcel-cache/
sudo chmod -R 777 /opt/cloudera/parcel-repo/
sudo chmod -R 777 /opt/cloudera/parcels/
```

- 2.2 Cloudera Manager Server requires an external mysql or postgresql database, pass it as a volume and mount to `/etc/cloudera-scm-server/db.properties`

```bash
## Extract default configuration.
docker run --rm \
--entrypoint /bin/sh wl4g/cloudera-manager-server:6.3.1 \
-c "cat /etc/cloudera-scm-server/db.properties" > /etc/cloudera-scm-server/db.properties
```

- 2.3 Init database for `cmf` :  [conf/cdh6.3.1_cmf_init.sql](conf/cdh6.3.1_cmf_init.sql)

- 2.4 Run container

```bash
docker run -d \
--name cm-server1 \
--network host \
-v /etc/cloudera-scm-server/db.properties:/etc/cloudera-scm-server/db.properties \
-v /mnt/disk1/log/cloudera-scm-server/:/var/log/cloudera-scm-server/ \
-v /opt/cloudera/csd/:/opt/cloudera/csd/ \
-v /opt/cloudera/parcel-cache/:/opt/cloudera/parcel-cache/ \
-v /opt/cloudera/parcel-repo/:/opt/cloudera/parcel-repo/ \
-v /opt/cloudera/parcels/:/opt/cloudera/parcels/ \
wl4g/cloudera-manager-server:6.3.1
```

- 2.5 Access Cloudera Manager Web:  [http://localhost:7180](http://localhost:7180)  &nbsp;&nbsp;&nbsp; login account:  `admin/admin`