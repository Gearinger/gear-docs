# Python中各类型数据的bool值

## 一、bool的本质

~~~python
# bool类型是int类型的子类，True==1，False==0
>>> True==1
True
>>> False==0
True
>>> True+False
1
>>> True+True
2

# 为避免判断错误，对于1和True、0和False之间的判断，应采用is
>>> 1 is True
False
>>> True is True
True

# python2中True和False不是关键字，python3中是关键字
>>> True = 2
  File "<stdin>", line 1
SyntaxError: can't assign to keyword
~~~

## 二、基础类型的判断

### 1、str的判断

可用于判空（""、None）

~~~python
# 对于不为空的字符串，其bool值为True，为""或None的对应False
>>> a, b, c, d = "test", "", "0", None
>>> (a, bool(a)), (b, bool(b)), (c, bool(c)), (d, bool(d))
(('test', True), ('', False), ('0', True), (None, False))

# 故，可采用以下方法
if "you":
    print("hello world")
elif "":
    print("nothing")
elif None:
    print("nothing")
else:
    print("")
~~~

### 2、int、float的判断

可用于判不为0的有效数

~~~python
# 对于不为0的数字，bool返回True
>>> bool(0.01)
True
>>> bool(1)
True
>>> bool(2)
True

# 0、0.0都返回False
>>> bool(0)
False
>>> bool(0.0)
False
>>> bool(0.0000)
False
~~~

### 3、列表、字典的判断

可用于判空

~~~python
# 凡是有元素在内的，都为True
>>> bool([])
False
>>> bool([1])
True
>>> bool(["1"])
True
>>> bool([0])
True
>>> bool({})
False
~~~

## 三、其他

### 方法、类等对象本身

返回True

~~~python
# 方法、类对象本身，bool类型为True
>>> def add(a, b):
...     return a + b
...
>>> bool(add)
True

>>> class test(list):
...     a=1
...
>>> bool(test)
True
~~~

### 5、方法的判断

对于有返回值的，根据返回值判断，无返回值的为True

~~~python
>>> def add(a, b):
...     return a + b
...
>>> bool(add(0, 0))
False
>>> bool(add(0, 1))
True

>>> def get():
...     a = 1
...
>>> bool(get())
False
~~~

### 6、实例的判断

对于继承于列表的，有元素则返回True

其他的，都返回True

~~~python
# 实例继承于列表、字典，且内部无元素，为False
>>> class test(list):
...     a=1
...
>>> test()
[]
>>> bool(test())
False

>>> class test2():
...     a = 1
...
>>> test2()
<__main__.test2 object at 0x000002176A5682B0>
>>> bool(test2())
True
~~~



# windows环境下使用virtualenv

1、创建一个文件夹
2、启动命令行并进入该文件夹，键入如下命令（前提是你已经安装了python）：

```cmd
pip install virtualenv     # 安装 virtualenv 
```


3、在想要创建的文件夹内，键入如下命令：

```cmd
virtualenv venv            # venv 为创建的虚拟环境名，可自定义
```

4、激活虚拟的环境，在创建虚拟环境的文件夹内，键入如下命令：

```cmd
venv\Scripts\activate      # 还是老规矩，venv是虚拟环境名
```



# 利用cx_Freeze打包python项目

- 步骤

Windows环境下打包结果为exe，Linux环境下打包结果为二进制文件。

Linux环境运行需使用命令：./文件

~~~sh
# 安装cx_freeze
pip install cx_freeze

# 打包项目
cd .../项目
cxfreeze 目标文件.py --target-dir 放置目标文件夹
~~~

- 问题
  - Windows环境

  根据错误提示，缺少包则在主文件（py文件）中导入相应的包

  - Linux环境

  根据错误提示，如果提示dist-info文件夹中缺少pycache，可直接删除该文件夹。（当前暂时认为dist-info文件夹是pip的缓存包文件，pip安装时会优先使用缓存）



# 系统信息获取

~~~python
import socket, getpass, os

# 获取当前系统主机名
host_name = socket.gethostname()
# 获取当前系统用户名
user_name = getpass.getuser()
# 获取当前系统用户目录
user_home = os.path.expanduser('~')
~~~

