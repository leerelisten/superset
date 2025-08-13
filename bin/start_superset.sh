#!/bin/bash

# Superset 启动脚本

# 设置环境变量
export PYTHONPATH=/data/app/superset:$PYTHONPATH
export SUPERSET_CONFIG_PATH=/data/app/superset/conf/superset_config.py
export FLASK_APP=superset
export SUPER_SECRET_KEY=z93IStZ9jZsnHUgJOOdS+3hXdqh6rIPjsHzsqjNVE6IcZzJ0X8qoDtHX

# 切换到 Superset 目录
cd /data/app/superset

# 激活虚拟环境
source superset-env/bin/activate

# 创建日志和PID文件目录（如果不存在）
mkdir -p /data/app/superset/log
mkdir -p /data/app/superset/bin

# 启动 Superset 并将日志输出到文件
# worker 个数提供并发数，timeout提供worker的静默超时重启时间
gunicorn \
    --workers 5 \
    --timeout 120 \
    --bind 10.10.120.225:8787 \
    --access-logfile /data/app/superset/log/access.log \
    --error-logfile /data/app/superset/log/error.log \
    --log-level info \
    --capture-output \
    --pid /data/app/superset/bin/superset.pid \
    --daemon \
    "superset.app:create_app()"

echo "Superset started in the background"
echo "Access logs are available at: /data/app/superset/log/access.log"
echo "Error logs are available at: /data/app/superset/log/error.log"
echo "PID file is located at: /data/app/superset/bin/superset.pid"

