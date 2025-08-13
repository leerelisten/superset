#!/bin/bash

# 启动所有 Celery 组件的脚本
# 包括 worker、beat 和 flower

# 设置环境变量
export PYTHONPATH=/data/app/superset:$PYTHONPATH
export SUPERSET_CONFIG_PATH=/data/app/superset/conf/superset_config.py

# 切换到 Superset 目录
cd /data/app/superset

# 激活虚拟环境
source superset-env/bin/activate

# 创建日志和PID文件目录（如果不存在）
mkdir -p /data/app/superset/log
mkdir -p /data/app/superset/bin

sudo chown -R nobody:nobody /data/app/superset/log
sudo chown -R nobody:nobody /data/app/superset/bin


echo "Starting Celery components..."

# 启动 Celery Worker
echo "Starting Celery Worker..."
celery --app=superset.tasks.celery_app:app worker \
    --pool=prefork \
    -O fair \
    -c 4 \
    --uid=nobody \
    --logfile=/data/app/superset/log/celery_worker.log \
    --pidfile=/data/app/superset/bin/celery_worker.pid \
    --detach &

sleep 5

# 启动 Celery Beat
echo "Starting Celery Beat..."
celery --app=superset.tasks.celery_app:app beat \
    --pidfile=/data/app/superset/bin/celery_beat.pid \
    --logfile=/data/app/superset/log/celery_beat.log \
    --loglevel=info \
    --detach &

sleep 5


# 启动 Celery Flower
echo "Starting Celery Flower..."
celery --app=superset.tasks.celery_app:app flower \
    --port=5555 \
    --pidfile=/data/app/superset/bin/celery_flower.pid \
    --logfile=/data/app/superset/log/celery_flower.log \
    --loglevel=info \
    --detach &

sleep 5


echo "All Celery components started"
echo "Worker logs: /data/app/superset/log/celery_worker.log"
echo "Beat logs: /data/app/superset/log/celery_beat.log"
echo "Flower logs: /data/app/superset/log/celery_flower.log"
echo "Flower UI: http://localhost:5555"

