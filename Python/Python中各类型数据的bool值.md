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




