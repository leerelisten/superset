import os
import sys
import logging
from typing import Optional
from celery.schedules import crontab
from datetime import timedelta
 # 确保PyMySQL兼容性（如果使用MySQL）
try:
    import pymysql
    pymysql.install_as_MySQLdb()
except ImportError:
    pass

BABEL_DEFAULT_LOCALE = 'zh'
BABEL_DEFAULT_FOLDER = 'superset/translations'
LANGUAGES  = {
     'en' : { 'flag' : 'us' , 'name' : 'English' },
     'zh' : { 'flag' : 'cn' , 'name' : 'Chinese' },
}

# MySQL数据库配置
SQLALCHEMY_DATABASE_URI = 'mysql://superset:rL3^wK1&dL@10.10.143.123:3306/superset'
SQLALCHEMY_TRACK_MODIFICATIONS = False

# 其他必要配置
SECRET_KEY = 'z93IStZ9jZsnHUgJOOdS+3hXdqh6rIPjsHzsqjNVE6IcZzJ0X8qoDtHX'
REDIS_HOST='10.10.104.171'
REDIS_PORT = 6379


WTF_CSRF_ENABLED = True
DEBUG = False
# 设置日志级别
LOG_LEVEL = logging.INFO

CELERY_BEAT_SCHEDULER_EXPIRES = timedelta(weeks=1)
class CeleryConfig:  # pylint: disable=too-few-public-methods
    broker_url = "redis://10.10.104.171:6379/0"
    imports = (
        "superset.sql_lab",
        "superset.tasks.scheduler",
        "superset.tasks.thumbnails",
        "superset.tasks.cache",
    )
    result_backend = "redis://10.10.104.171:6379/0"
    worker_prefetch_multiplier = 5
    task_acks_late = False
    task_annotations = {
        "sql_lab.get_sql_results": {
            "rate_limit": "100/s",
        },
    }
    beat_schedule = {
        "reports.scheduler": {
            "task": "reports.scheduler",
            "schedule": crontab(minute="*", hour="*"),
            "options": {"expires": int(CELERY_BEAT_SCHEDULER_EXPIRES.total_seconds())},
        },
        "reports.prune_log": {
            "task": "reports.prune_log",
            "schedule": crontab(minute=0, hour=0),
        },
        # Uncomment to enable pruning of the query table
        # "prune_query": {
        #     "task": "prune_query",
        #     "schedule": crontab(minute=0, hour=0, day_of_month=1),
        #     "kwargs": {"retention_period_days": 180},
        # },
        # Uncomment to enable pruning of the logs table
        # "prune_logs": {
        #     "task": "prune_logs",
        #     "schedule": crontab(minute="*", hour="*"),
        #     "kwargs": {"retention_period_days": 180},
        # },
    }
# 使用 Redis
from flask_caching.backends.rediscache import RedisCache
CELERY_BEAT_SCHEDULER_EXPIRES = timedelta(weeks=1)
RESULTS_BACKEND = RedisCache(
    host='10.10.104.171', port=6379, key_prefix='superset_results')

CELERY_CONFIG: type[CeleryConfig] = CeleryConfig
# 使PyMySQL兼容MySQLdb
# 缓存
# 仪表盘过滤器状态
FILTER_STATE_CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_DEFAULT_TIMEOUT': 86400,
    'CACHE_KEY_PREFIX': 'superset_filter_cache',
    'CACHE_REDIS_URL': 'redis://10.10.104.171:6379/0'
}

# 探索图表表单数据缓存
EXPLORE_FORM_DATA_CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_DEFAULT_TIMEOUT': 86400,
    'CACHE_KEY_PREFIX': 'superset_form_data_cache',
    'CACHE_REDIS_URL': 'redis://10.10.104.171:6379/0'
}
# 元数据缓存
CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_DEFAULT_TIMEOUT': 86400,
    'CACHE_KEY_PREFIX': 'superset_metadata_cache',
    'CACHE_REDIS_URL': 'redis://10.10.104.171:6379/0'
}

# 从数据集查询的图表数据
DATA_CACHE_CONFIG = {
    'CACHE_TYPE': 'RedisCache',
    'CACHE_DEFAULT_TIMEOUT': 86400,
    'CACHE_KEY_PREFIX': 'superset_data_cache',
    'CACHE_REDIS_URL': 'redis://10.10.104.171:6379/1'
}
