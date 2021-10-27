FROM centos:centos7
MAINTAINER zhaofakai "fkzhao@outlook.com"

USER root

RUN set -x \
    && yum update -y \
    && yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel wget iputils nc  vim libcurl net-tools

RUN mkdir -p /home/work/nacos-confd \
    && mkdir -p /etc/confd/{conf.d,templates}

COPY entrypoint.sh /home/work
ADD prometheus-2.30.3.linux-amd64.tar.gz /home/work
RUN mv /home/work/prometheus-2.30.3.linux-amd64 /home/work/prometheus \
    && mkdir -p /home/work/prometheus/{conf,data}
ADD prometheus.yml /home/work/prometheus/conf

ADD nacos-server-2.0.3.tar.gz /home/work
ADD nacos-confd/confd /home/work/nacos-confd
ADD nacos-confd/start.sh /home/work/nacos-confd
COPY nacos-confd/conf.d/* etc/confd/conf.d
COPY nacos-confd/templates/* /etc/confd/templates


VOLUME ["/home/work/prometheus/conf", "/home/work/prometheus/data", "/home/work/nacos/data", "/home/work/nacos/logs"]

EXPOSE 8848/tcp 9090/tcp
WORKDIR /home/work
CMD ["sh", "/home/work/entrypoint.sh"]
