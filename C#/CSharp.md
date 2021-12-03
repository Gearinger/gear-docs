## 特性

[Attribute]

​		使用特性，可以有效地将元数据或声明性信息与代码（程序集、类型、方法、属性等）相关联。 将特性与程序实体相关联后，可以在运行时使用*反射*这项技术查询特性。

<u>		被调用时，相当于实例化一个类。</u>

**使用特性**

```C#
[Serializable] 
public class SampleClass 
{ // Objects of this type can be serialized. }
```

**自定义特性**

```C#
[System.AttributeUsage(System.AttributeTargets.Class |  
                       System.AttributeTargets.Struct)  
]  
public class Author : System.Attribute  
{  
    private string name;  
    public double version;  
  
    public Author(string name)  
    {  
        this.name = name;  
        version = 1.0;  
    }  
}
```

**访问方式**：

```c#
//使用反射获取实例temp的Type
Type t = temp.GetType();
//获取t的所有特性，得到一个列表
System.Attribute[] attrs = System.Attribute.GetCustomAttributes(t);
//判断t是否有特性Author(Author与AuthorAttribute等价)
bool def = t.IsDefined(typeof(AuthorAttribute),false);
```

**用途**：特征标识，相当于书签（例：可用于权限管理，对方法使用特性，限制某些成员才能访问）

---

## 线程池的使用示例

```C#
// 传递任务状态
List<WaitHandle> waitHandles = new List<WaitHandle>();
// 遍历上传照片
string[] imageFiles = Directory.GetFiles(WorkspaceModel.ImagePath, "*.jpg");
bool pool = ThreadPool.SetMinThreads(8, 8);
if (pool)
{
    foreach (var imageFile in imageFiles)
    {
        ManualResetEvent wh = new ManualResetEvent(false);
        waitHandles.Add(wh);
        ThreadPool.QueueUserWorkItem(obj => Upload((ManualResetEvent)obj, imageFile), wh);
    }
}
// 等待所有任务执行完成
WaitHandle.WaitAll(waitHandles.ToArray());
WaitHelper.CloseWaiting();
```

```C#
private async void Upload(ManualResetEvent state, string imageFile)
{
    bool isSucceed = await OneImageUpload(imageFile);
    if (!isSucceed)
    {
        LogHelper.Error($"上传{imageFile}失败！");
        //throw new Exception($"上传{imageFile}失败！");
    }
    else
    {
        LogHelper.Info($"上传{imageFile}成功！");
    }
    // 设置状态为结束
    state.Set();
}
```

---

## 获取方法名、执行文件路径、执行行号

CallerMemberName、CallerFilePath和CallerLineNumber

如果想区分调用来源就比较麻烦了。在.Net 4.5中引入了三个Attribute：CallerMemberName、CallerFilePath和CallerLineNumber 。在编译器的配合下，分别可以获取到调用函数（准确讲应该是成员）名称，调用文件及调用行号。这时可以把方法改成：

```
/// <summary>
/// Writes an error level logging message.
/// </summary>
/// <param name="message">The message to be written.</param>
public void WriteError(object message,
[CallerMemberName] string memberName = "",
[CallerFilePath] string sourceFilePath = "",
[CallerLineNumber] int sourceLineNumber = 0)
{
	_log4Net.ErrorFormat("文件:{0} 行号:{1} 方法名:{2},消息:{3}", sourceFilePath, sourceLineNumber, memberName, message);
}
```

这样就可以区分调用来源了。另外，在构造函数，析构函数、属性等特殊的地方调用CallerMemberName属性所标记的函数时，获取的值有所不同，其取值如下表所示：

| **调用的地方**         | **CallerMemberName获取的结果**         |
| ---------------------- | -------------------------------------- |
| 方法、属性或事件       | 方法，属性或事件的名称                 |
| 构造函数               | 字符串 ".ctor"                         |
| 静态构造函数           | 字符串 ".cctor"                        |
| 析构函数               | 该字符串 "Finalize"                    |
| 用户定义的运算符或转换 | 生成的名称成员，例如， "op_Addition"。 |
| 特性构造函数           | 特性所应用的成员的名称                 |