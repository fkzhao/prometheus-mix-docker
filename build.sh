#!/bin/bash

# @Author: zhaofakai
# @Date:   2021-10-25 15:14:05
# @Last Modified by:   zhaofakai
# @Last Modified time: 2021-10-27 23:24:50

set -e

if [ ! -f "nacos-server-2.0.3.tar.gz" ]; then
	wget -O nacos-server-2.0.3.tar.gz --no-check-certificate "https://github.com/alibaba/nacos/releases/download/2.0.3/nacos-server-2.0.3.tar.gz"

fi

if [ ! -f "prometheus-2.30.3.linux-amd64.tar.gz" ]; then
	wget -O prometheus-2.30.3.linux-amd64.tar.gz --no-check-certificate "https://github.com/prometheus/prometheus/releases/download/v2.30.3/prometheus-2.30.3.linux-amd64.tar.gz"
fi


check_results=`docker image ls | grep airec-prometheus | grep -v grep | wc -l`

if [ ${check_results} -eq 1 ];then
	echo "airec-prometheus:v1 existed. will delete.";
	echo "deleting";
	docker image rm -f airec-prometheus:v1
	echo "delete airec-prometheus:v1 success.";
fi


docker build -t airec-prometheus:v1 .

echo "run airec-prometheus:v1";
docker run --rm -it -p 8848:8848 -p 9090:9090 airec-prometheus:v1 /bin/bash
# docker run -d -p 8848:8848 -p 9090:9090 airec-prometheus:v1