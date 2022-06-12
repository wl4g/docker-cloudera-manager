# Copyright 2017 ~ 2025 the original author or authors. <wanglsir@gmail.com, 983708408@qq.com>
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#      http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

## see:https://blogs.wl4g.com/archives/2969
FROM centos:centos7.9.2009 AS cm_base
LABEL maintainer="Wanglsir<983708408@qq.com>, Wanglsir<Wanglsir@gmail.com>"

#ADD https://github.com/krallin/tini/releases/download/v0.19.0/tini /sbin/tini
ADD https://gitee.com/wl4g-k8s/tini/attach_files/1092261/download/tini /sbin/tini

## see:https://community.cloudera.com/t5/Support-Questions/What-exact-dependencies-required-in-lib-lsb-init-functions/m-p/36174
## see:https://github.com/CentOS/sig-cloud-instance-images/issues/28#issuecomment-255595715
## see:https://developer.aliyun.com/mirror/centos?spm=a2c6h.13651102.0.0.3e221b11mqU6Vc
# curl -skL -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo \
RUN \
yum clean all && yum makecache \
&& yum install -y ntp java-1.8.0-openjdk.x86_64 bind-utils \
psmisc cyrus-sasl-plain openssl cyrus-sasl-gssapi fuse portmap perl fuse-libs httpd mod_ssl \
openssl-devel python-psycopg2 MySQL-python psmisc iproute redhat-lsb-core initscripts \
&& rm /etc/localtime \
&& ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& chmod +x /sbin/tini

WORKDIR /tmp/images/cm_base

FROM cm_base AS cm_agent
LABEL maintainer="Wanglsir<983708408@qq.com>, Wanglsir<Wanglsir@gmail.com>"

ENV CLOUDERA_ROOT=/opt/cloudera
ENV CMF_DEFAULTS=/etc/default/cloudera-scm-agent

## cm-server needs to communicate with cm-agent using ssh to process management commands.
## see:https://blogs.wl4g.com/archives/2044
## Among them, openssh-clients is used to transfer parcels using scp during installation
RUN \
useradd cloudera-scm \
&& mkdir -p /opt/cloudera /etc/cloudera-scm-agent /run/cloudera-scm-agent/supervisor \
&& yum install -y passwd net-tools openssl openssh-server openssh-clients \
&& echo y|ssh-keygen -q -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key -N '' \
&& echo y|ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
&& echo y|ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N '' \
&& sed -i 's/#Port 22/Port 122/' /etc/ssh/sshd_config \
&& echo 123456 | passwd --stdin root

COPY material/cloudera-manager-daemons*.rpm /
COPY material/cloudera-manager-agent*.rpm /
COPY conf/supervisord.conf /run/cloudera-scm-agent/supervisor/
COPY script/docker-entrypoint.sh /

RUN \
rpm -iv /cloudera-manager-daemons-*.rpm \
&& rpm -iv /cloudera-manager-agent-*.rpm \
&& rm -rf /*.rpm \
&& chmod 777 /docker-entrypoint.sh \
&& chown -R cloudera-scm:cloudera-scm /docker-entrypoint.sh \
&& chown -R cloudera-scm:cloudera-scm ${CLOUDERA_ROOT} \
&& chown -R cloudera-scm:cloudera-scm /etc/cloudera-scm-agent \
&& chown -R cloudera-scm:cloudera-scm /run/cloudera-scm-agent \
&& yum install -y sudo \
&& echo "cloudera-scm  ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers \
&& yum clean all

## cm-agent should be run as root to manage CDH components.
# USER cloudera-scm

ENTRYPOINT ["/sbin/tini", "--", "/docker-entrypoint.sh", "start"]