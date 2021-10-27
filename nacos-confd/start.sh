#/bin/bash

nohup ./confd -backend=nacos -node=http://127.0.0.1:8848/nacos -username=nacos -password=nacos -watch &


