#!/bin/bash

# Superset 停止脚本

PIDFILE="/data/app/superset/bin/superset.pid"
LOGFILE="/data/app/superset/log/error.log"

if [ -f "$PIDFILE" ]; then
    PID=$(cat "$PIDFILE")
    echo "Stopping Superset with PID: $PID"
    kill -TERM $PID

    # 等待进程结束
    while kill -0 $PID 2>/dev/null; do
        echo "Waiting for Superset to stop..."
        sleep 1
    done

    # 删除 PID 文件
    rm -f "$PIDFILE"

    echo "Superset stopped"
else
    echo "Superset PID file not found. Is Superset running?"
    echo "If Superset is running, please use 'pkill' to stop it manually."
fi

