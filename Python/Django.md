## 一、概要

----

### 创建项目及应用

```Python


# 启动服务器
$ python manage.py runserver IP地址:端口号

# 创建项目
$ django-admin startproject mysite

# 创建应用
$ python manage.py startapp polls

# 建表
$ python manage.py migrate

# 记录模型修改
$ python manage.py makemigrations 应用名称
```

---

### Url

```python
urlpatterns = [
	url('^home/'), home), 					# url方法属于旧版本，比path麻烦，推荐使用path
    path('polls/', include('polls.urls')),
    path('admin/', admin.site.urls),
]
```

### Views

```python
def my_view(request):
    # View code here...
    return render(request, 'myapp/index.html', {
        'foo': 'bar',
    }, content_type='application/xhtml+xml')
```

---

### Models

```python
# polls/models.py
from django.db import models

class Question(models.Model):
    question_text = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')

class Choice(models.Model):
    question = models.ForeignKey(Question, on_delete=models.CASCADE)
    choice_text = models.CharField(max_length=200)
    votes = models.IntegerField(default=0)
```

**<u>注：应用注册一般直接使用应用名称就行，如下</u>**

```python
# mysite/settings.py

INSTALLED_APPS = [
'polls.apps.PollsConfig',	#一般简化为'polls',
'django.contrib.admin',
'django.contrib.auth',
'django.contrib.contenttypes',
'django.contrib.sessions',
'django.contrib.messages',
'django.contrib.staticfiles',
]
```

#### API

```python
$ python manage.py shell
import django
django.setup()	#启动Django
m = Model(properName="What's new?") #Model为模型中类名称，properName为属性名

# 创建一个新的question对象
    # Django推荐使用timezone.now()代替python内置的datetime.datetime.now()
    # 这个timezone就来自于Django的依赖库pytz
    from django.utils import timezone
    >>> q = Question(question_text="What's new?", pub_date=timezone.now())

    # 你必须显式的调用save()方法，才能将对象保存到数据库内
    >>> q.save()

    # 默认情况，你会自动获得一个自增的名为id的主键
    >>> q.id
    1

    # 通过python的属性调用方式，访问模型字段的值
    >>> q.question_text
    "What's new?"
    >>> q.pub_date
    datetime.datetime(2012, 2, 26, 13, 0, 0, 775217, tzinfo=<UTC>)

    # 通过修改属性来修改字段的值，然后显式的调用save方法进行保存。
    >>> q.question_text = "What's up?"
    >>> q.save()

    # objects.all() 用于查询数据库内的所有questions
    >>> Question.objects.all()
    <QuerySet [<Question: Question object>]>

```



### 设置（setting.py）

```python
# 设置数据库
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```



**INSTALLED_APPS(默认安装应用)：**

- django.contrib.admin：admin管理后台站点
- django.contrib.auth：身份认证系统
- django.contrib.contenttypes：内容类型框架
- django.contrib.sessions：会话框架
- django.contrib.messages：消息框架
- django.contrib.staticfiles：静态文件管理框架



### 测试



### 静态文件



### admin



## 二、详细教程

