> 记录使用 `docsify` 过程中遇到的问题

### 问题

#### 1、跨域问题

检查是否用文件形式打开的网页。应采用服务器的方式。

~~~ sh
docsify serve
~~~

或者

~~~sh
python -m http.server 8000
~~~

#### 2、封面视频文件

封面不能放置视频文件

#### 3、封面按钮显示bug

删除按钮间的空白行（typora会在每行之间插入空白行）

#### 4、Centos系统大小写敏感

readme文件名全部使用大写“README.md”

#### 5、关于文件缺失

_sidebar在每个文件夹下都必须存在，__navbar可不存在。

