#!/bin/bash

# 停止所有 Celery 组件的脚本

PID_DIR="/data/app/superset/bin"
LOG_DIR="/data/app/superset/log"

echo "Stopping Celery components..."

# 停止 Celery Flower
if [ -f "$PID_DIR/celery_flower.pid" ]; then
    FLOWER_PID=$(cat "$PID_DIR/celery_flower.pid")
    echo "Stopping Celery Flower (PID: $FLOWER_PID)..."
    kill -TERM $FLOWER_PID 2>/dev/null || true
    
    # 等待进程结束
    while kill -0 $FLOWER_PID 2>/dev/null; do
        echo "Waiting for Celery Flower to stop..."
        sleep 1
    done
    
    # 删除 PID 文件
    rm -f "$PID_DIR/celery_flower.pid"
    echo "Celery Flower stopped"
else
    echo "Celery Flower PID file not found"
fi

# 停止 Celery Beat
if [ -f "$PID_DIR/celery_beat.pid" ]; then
    BEAT_PID=$(cat "$PID_DIR/celery_beat.pid")
    echo "Stopping Celery Beat (PID: $BEAT_PID)..."
    kill -TERM $BEAT_PID 2>/dev/null || true
    
    # 等待进程结束
    while kill -0 $BEAT_PID 2>/dev/null; do
        echo "Waiting for Celery Beat to stop..."
        sleep 1
    done
    
    # 删除 PID 文件
    rm -f "$PID_DIR/celery_beat.pid"
    echo "Celery Beat stopped"
else
    echo "Celery Beat PID file not found"
fi

# 停止 Celery Worker
if [ -f "$PID_DIR/celery_worker.pid" ]; then
    WORKER_PID=$(cat "$PID_DIR/celery_worker.pid")
    echo "Stopping Celery Worker (PID: $WORKER_PID)..."
    kill -TERM $WORKER_PID 2>/dev/null || true
    
    # 等待进程结束
    while kill -0 $WORKER_PID 2>/dev/null; do
        echo "Waiting for Celery Worker to stop..."
        sleep 1
    done
    
    # 删除 PID 文件
    rm -f "$PID_DIR/celery_worker.pid"
    echo "Celery Worker stopped"
else
    echo "Celery Worker PID file not found"
fi

echo "All Celery components stopped"
