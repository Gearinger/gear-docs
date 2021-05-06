# Celery (适配Python2.7.5)

### 版本适配

```sh
# Python2.7
python==2.7.5
celery==3.1.25
redis==2.10.6
```

---

### 安装

~~~
pip install celery==3.1.25 redis==2.10.6
~~~

---

### DEMO

~~~
- celery_work
  - celery_config.py
  - task.py
  - run.cmd
  - test.py
~~~

> celery_config.py

~~~python
# celery_config.py
enable_utc = True
CELERY_TIMEZONE = 'Asia/Shanghai'
result_expires=3600

BROKER_URL = 'redis://localhost:6379/0'
CELERY_RESULT_BACKEND = 'redis://localhost:6379/1'

~~~

> task.py

~~~python
# task.py
from celery import Celery


app = Celery("tasks")
app.config_from_object("celeryconfig")

@app.task
def add(x, y):
    return x + y
~~~

> run.cmd

~~~sh
celery -A task worker --loglevel=info
~~~

> test.py

~~~python
from task import add

r = add.delay(4, 14)
print(r.result)
~~~

- 运行cmd，启动消息服务器

- 运行test.py，测试任务的执行

---

### 中间件配置

> 建议从.py文件获取配置。如上，同级目录创建 celery_config.py 作为配置文件。
>
> 中间件可选择 RabbitMQ、Redis、常用数据库（不建议使用）

- Redis

~~~python
# 配置消息中间件。格式：redis://:password@hostname:port/db_number
BROKER_URL = 'redis://localhost:6379/0'

# 超时时间
BROKER_TRANSPORT_OPTIONS = {'visibility_timeout': 3600}

# 任务结果存储
CELERY_RESULT_BACKEND = 'redis://localhost:6379/0'

# 广播消息是否可见
BROKER_TRANSPORT_OPTIONS = {'fanout_prefix': True}

# 时区
CELERY_TIMEZONE = 'Asia/Shanghai'
~~~



---

