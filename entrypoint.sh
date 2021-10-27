#!/bin/bash
#
set -e
source /root/.bashrc

# 启动nacos
sh /home/work/nacos/bin/startup.sh -m standalone &> /dev/null
echo "wating nacos start."
while [[ true ]]; do
  ret=`netstat -aptn | grep '0.0.0.0:8848' | wc -l`
  if [ $ret -gt 0 ]; then
    break
  fi
  sleep 1
done

# 后台运行启动confid
echo "nacos-confd started."
nohup /home/work/nacos-confd/confd -backend=nacos -node=http://127.0.0.1:8848/nacos -username=nacos -password=nacos -watch > nacos-confd.log 2>&1 &
# 启动prometheus
echo "prometheus start."
/home/work/prometheus/prometheus --config.file=/home/work/prometheus/conf/prometheus.yml --storage.tsdb.path=/home/work/prometheus/data --storage.tsdb.retention.time=90d --web.enable-lifecycle
