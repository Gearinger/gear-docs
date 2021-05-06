### 特性

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