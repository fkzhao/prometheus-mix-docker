FROM centos:centos7
MAINTAINER zhaofakai "fkzhao@outlook.com"

USER root

RUN echo "alias ls='ls --color'" >> /root/.bashrc \
	&& echo "alias ll='ls -lh'" >> /root/.bashrc \
	&& echo "source /etc/profile" >> /root/.bashrc \
	&& source /root/.bashrc


RUN set -x \
    && yum update -y \
    && yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel wget iputils nc  vim libcurl net-tools

RUN mkdir -p /home/work && cd /home/work


COPY entrypoint.sh /home/work
ADD prometheus-2.30.3.linux-amd64.tar.gz /home/work
# ADD alertmanager-0.23.0.linux-amd64.tar.gz /home/work
# ADD blackbox_exporter-0.19.0.linux-amd64.tar.gz /home/work
ADD nacos-server-2.0.3.tar.gz /home/work

RUN mkdir -p /home/work/nacos-confd
ADD nacos-confd/confd /home/work/nacos-confd
ADD nacos-confd/start.sh /home/work/nacos-confd
RUN mkdir -p /etc/confd \
	&& mkdir -p /etc/confd/conf.d \
	&& mkdir -p /etc/confd/templates

COPY nacos-confd/conf.d/* etc/confd/conf.d
COPY nacos-confd/templates/* /etc/confd/templates

EXPOSE 8848/tcp 9090/tcp
WORKDIR /home/work
CMD ["sh", "/home/work/entrypoint.sh"]
