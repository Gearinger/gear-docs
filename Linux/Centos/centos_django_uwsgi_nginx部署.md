**详细步骤(下面步骤都是ROOT权限执行):**

**一、更新系统软件包**
yum update -y

**二、安装软件管理包和可能使用的依赖**

```
yum -y groupinstall "Development tools"
yum install openssl-devel bzip2-devel expat-devel gdbm-devel readline-devel sqlite-devel psmisc libffi-devel
```

**三、安装Pyhton3**

```
yum install python3
```

**四、查看Python3和pip3安装情况**

![timg.jpg](https://www.django.cn/media/upimg/timg_20180709220813_231.jpg)

**五、安装virtualenv ，建议大家都安装一个virtualenv，方便不同版本项目管理。**

```
pip3 install virtualenv
```

建立软链接

```
ln -s /usr/local/python3/bin/virtualenv /usr/bin/virtualenv
```

安装成功在根目录下建立两个文件夹，主要用于存放env和网站文件的。(个人习惯，其它人可根据自己的实际情况处理)

```
mkdir -p /data/env
mkdir -p /data/wwwroot
```

**六、切换到/data/env/下，创建指定版本的虚拟环境。**

```
virtualenv --python=/usr/bin/python3 pyweb
```

然后进入/data/env/pyweb/bin
启动虚拟环境：

```
source activate
```

![img]()

![timg.jpg](https://www.django.cn/media/upimg/timg_20180709220840_146.jpg)

留意我标记的位置，出现(pyweb)，说明是成功进入虚拟环境。

**七、虚拟环境里用pip3安django和uwsgi**

```
pip3 install django （如果用于生产的话，则需要指定安装和你项目相同的版本）
pip3 install uwsgi
```

**留意：****uwsgi要安装两次**，先在系统里安装一次，然后进入对应的虚拟环境安装一次。

给uwsgi建立软链接，方便使用

```
ln -s /usr/local/python3/bin/uwsgi /usr/bin/uwsgi
```

**八、安装sqlite**

```
wget https://www.sqlite.org/2020/sqlite-autoconf-3310100.tar.gz
tar -xvzf sqlite-autoconf-3310100.tar.gz
#编译安装：
  ./configure
  make
  make install
  ldconfig   
更新python3中使用的版本
export LD_LIBRARY_PATH="/usr/local/lib"
source ~/.bashrc
```



### 问题

在settings中静态文件目录设置的有问题（其余路径设置同理）

url必须带"/"，dirs和root中不需要带"/"

```
# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/2.1/howto/static-files/
STATIC_URL = '/static/'

STATICFILES_DIRS = (
    os.path.join(BASE_DIR, 'static'),
)

MEDIA_URL = '/media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

```

