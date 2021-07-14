# Java学习日志

> 2020年9月24日
>
> - idea 双击 shift 进行全局搜索（包含文件、功能、类、函数、变量等）
> - 将项目添加到 Maven 管理：pom.xml右键Add Maven Projects
> - 重新载入 Maven 项目：Reload All Maven Projects
> - 读取yaml文件报错expect,block end,but found scalar：yaml文件的格式要求严格，



## 一、环境配置
### 版本

最常用的版本为Java8

JDK8 == JDK1.8

### 1、Java安装

- [Java8下载链接](https://download.java.net/openjdk/jdk8u41/ri/openjdk-8u41-b04-windows-i586-14_jan_2020.zip): https://download.java.net/openjdk/jdk8u41/ri/openjdk-8u41-b04-windows-i586-14_jan_2020.zip
- 若java目录下无jre文件夹，可以管理员身份执行以下命令
~~~sh
bin\jlink.exe --module-path jmods --add-modules java.desktop --output jre
~~~
- 环境变量配置
~~~
JAVA_HOME   C:\Program Files\Java\java-se-8u41-ri

PATH        %Java_Home%\bin;%Java_Home%\jre\bin

CLASSPATH   .;%Java_Home%\bin;%Java_Home%\lib\dt.jar;%Java_Home%\lib\tools.jar


~~~

### 2、Maven安装及配置




## 二、整体结构概要
### 1、Spring Cloud

[结构理解](https://zhuanlan.zhihu.com/p/95696180?from_voters_page=true)

SpringCloud 主要包含网关、负载均衡、熔断降级、服务注册中心、配置中心、服务调用、消息总线、服务

![img](https://picb.zhimg.com/80/v2-3a132c503bb7cde19314acc8a4866c4b_1440w.jpg)

#### （1）Nacos

配置注册、配置移除、服务注册、服务移除、心跳



## 三、注解

### 1、内置的注解

- **作用在代码的注解是**
  - @Override - 可写可不写。写的话，会检查父类或接口中是否存在该方法，不存在则报错。
  - @Deprecated - 标记过时方法。如果使用该方法，会报编译警告。
  - @SuppressWarnings - 指示编译器去忽略注解中声明的警告。

- **作用在其他注解的注解(或者说 元注解)是:**
  - @Retention - 标识这个注解怎么保存，是只在代码中，还是编入class文件中，或者是在运行时可以通过反射访问。
  - @Documented - 标记这些注解是否包含在用户文档中。
  - @Target - 标记这个注解应该是哪种 Java 成员。
  - @Inherited - 标记这个注解是继承于哪个注解类(默认 注解并没有继承于任何子类)

- **从 Java 7 开始，额外添加了 3 个注解:**
  - @SafeVarargs - Java 7 开始支持，忽略任何使用参数为泛型变量的方法或构造函数调用产生的警告。
  - @FunctionalInterface - Java 8 开始支持，标识一个匿名函数或函数式接口。
  - @Repeatable - Java 8 开始支持，标识某注解可以在同一个声明上使用多次。

### 2、自定义注解

~~~java
//ElementType 是 Enum 枚举类型，它用来指定 Annotation 的类型
public enum ElementType {
    TYPE,               /* 类、接口（包括注释类型）或枚举声明  */
    FIELD,              /* 字段声明（包括枚举常量）  */
    METHOD,             /* 方法声明  */
    PARAMETER,          /* 参数声明  */
    CONSTRUCTOR,        /* 构造方法声明  */
    LOCAL_VARIABLE,     /* 局部变量声明  */
    ANNOTATION_TYPE,    /* 注释类型声明  */
    PACKAGE             /* 包声明  */
}


//RetentionPolicy 是 Enum 枚举类型，它用来指定 Annotation 的策略。通俗点说，就是不同 RetentionPolicy 类型的 Annotation 的作用域不同
public enum RetentionPolicy {
    SOURCE,            /* Annotation信息仅存在于编译器处理期间，编译器处理完之后就没有该Annotation信息了  */
    CLASS,             /* 编译器将Annotation存储于类对应的.class文件中。默认行为  */
    RUNTIME            /* 编译器将Annotation存储于class文件中，并且可由JVM读入 */
}
~~~



```java
//表示它可以出现在 javadoc 中
@Documented
//作用的对象类型 /* 类、接口（包括注释类型）或枚举声明  */
@Target(ElementType.TYPE)
//编译器会将该 Annotation 信息保留在 .class 文件中，并且能被虚拟机读取
@Retention(RetentionPolicy.RUNTIME)
// @interface 定义注解时，意味着它实现了 java.lang.annotation.Annotation 接口，即该注解就是一个Annotation。定义 Annotation 时，@interface 是必须的
public @interface MyAnnotation1 {
}
```

### 3、反射中使用注解

AnnotationTest.java

~~~java
import java.lang.annotation.Annotation;
import java.lang.annotation.Target;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Inherited;
import java.lang.reflect.Method;

/**
 * Annotation在反射函数中的使用示例
 */
@Retention(RetentionPolicy.RUNTIME)
@interface MyAnnotation {
    String[] value() default "unknown";
}

/**
 * Person类。它会使用MyAnnotation注解。
 */
class Person {
   
    /**
     * empty()方法同时被 "@Deprecated" 和 "@MyAnnotation(value={"a","b"})"所标注
     * (01) @Deprecated，意味着empty()方法，不再被建议使用
     * (02) @MyAnnotation, 意味着empty() 方法对应的MyAnnotation的value值是默认值"unknown"
     */
    @MyAnnotation
    @Deprecated
    public void empty(){
        System.out.println("\nempty");
    }
   
    /**
     * sombody() 被 @MyAnnotation(value={"girl","boy"}) 所标注，
     * @MyAnnotation(value={"girl","boy"}), 意味着MyAnnotation的value值是{"girl","boy"}
     */
    @MyAnnotation(value={"girl","boy"})
    public void somebody(String name, int age){
        System.out.println("\nsomebody: "+name+", "+age);
    }
}

public class AnnotationTest {

    public static void main(String[] args) throws Exception {
       
        // 新建Person
        Person person = new Person();
        // 获取Person的Class实例
        Class<Person> c = Person.class;
        // 获取 somebody() 方法的Method实例
        Method mSomebody = c.getMethod("somebody", new Class[]{String.class, int.class});
        // 执行该方法
        mSomebody.invoke(person, new Object[]{"lily", 18});
        iteratorAnnotations(mSomebody);
       

        // 获取 somebody() 方法的Method实例
        Method mEmpty = c.getMethod("empty", new Class[]{});
        // 执行该方法
        mEmpty.invoke(person, new Object[]{});        
        iteratorAnnotations(mEmpty);
    }
   
    public static void iteratorAnnotations(Method method) {

        // 判断 somebody() 方法是否包含MyAnnotation注解
        if(method.isAnnotationPresent(MyAnnotation.class)){
            // 获取该方法的MyAnnotation注解实例
            MyAnnotation myAnnotation = method.getAnnotation(MyAnnotation.class);
            // 获取 myAnnotation的值，并打印出来
            String[] values = myAnnotation.value();
            for (String str:values)
                System.out.printf(str+", ");
            System.out.println();
        }
       
        // 获取方法上的所有注解，并打印出来
        Annotation[] annotations = method.getAnnotations();
        for(Annotation annotation : annotations){
            System.out.println(annotation);
        }
    }
}
~~~

运行结果：

~~~
somebody: lily, 18
girl, boy, 
@com.skywang.annotation.MyAnnotation(value=[girl, boy])

empty
unknown, 
@com.skywang.annotation.MyAnnotation(value=[unknown])
@java.lang.Deprecated()
~~~

### 4、常用注解

```
Data

AllArgsConstructor

NoArgsConstructor

ApiModel

ApiModelProperty

JsonFormat

DateTimeFormat

Table

Id

Generated

Slf4j

Transactional

Service/Entity


```

## 四、entity（BO）、dao、service、dto

### 1、entity

数据库表的model，直接对应列名

### 2、dao

数据库的select、update、delete等操作方法。分为接口和接口实现类

### 3、service

集成业务函数，供controller调用

### 4、dto

对接前端的数据传输model，以前端需求字段为准。



> Java中简单类成为POJO （Plain Ordinary Java Object）简单的Java对象。



## 五、JPA

自定义的简单查询就是根据方法名来自动生成 SQL，主要的语法是findXXBy,readAXXBy,queryXXBy,countXXBy, getXXBy后面跟属性名称：

```
User findByUserName(String userName);
```

也使用一些加一些关键字And、 Or

```
User findByUserNameOrEmail(String username, String email);
```

修改、删除、统计也是类似语法

```
Long deleteById(Long id);
Long countByUserName(String userName)
```

基本上 SQL 体系中的关键词都可以使用，例如：LIKE、 IgnoreCase、 OrderBy。

```
List<User> findByEmailLike(String email);
User findByUserNameIgnoreCase(String userName);
List<User> findByUserNameOrderByEmailDesc(String email);
```

具体的关键字，使用方法和生产成SQL如下表所示

| Keyword           | Sample                                  | JPQL snippet                                                 |
| ----------------- | --------------------------------------- | ------------------------------------------------------------ |
| And               | findByLastnameAndFirstname              | … where x.lastname = ?1 and x.firstname = ?2                 |
| Or                | findByLastnameOrFirstname               | … where x.lastname = ?1 or x.firstname = ?2                  |
| Is,Equals         | findByFirstnameIs,findByFirstnameEquals | … where x.firstname = ?1                                     |
| Between           | findByStartDateBetween                  | … where x.startDate between ?1 and ?2                        |
| LessThan          | findByAgeLessThan                       | … where x.age < ?1                                           |
| LessThanEqual     | findByAgeLessThanEqual                  | … where x.age ⇐ ?1                                           |
| GreaterThan       | findByAgeGreaterThan                    | … where x.age > ?1                                           |
| GreaterThanEqual  | findByAgeGreaterThanEqual               | … where x.age >= ?1                                          |
| After             | findByStartDateAfter                    | … where x.startDate > ?1                                     |
| Before            | findByStartDateBefore                   | … where x.startDate < ?1                                     |
| IsNull            | findByAgeIsNull                         | … where x.age is null                                        |
| IsNotNull,NotNull | findByAge(Is)NotNull                    | … where x.age not null                                       |
| Like              | findByFirstnameLike                     | … where x.firstname like ?1                                  |
| NotLike           | findByFirstnameNotLike                  | … where x.firstname not like ?1                              |
| StartingWith      | findByFirstnameStartingWith             | … where x.firstname like ?1 (parameter bound with appended %) |
| EndingWith        | findByFirstnameEndingWith               | … where x.firstname like ?1 (parameter bound with prepended %) |
| Containing        | findByFirstnameContaining               | … where x.firstname like ?1 (parameter bound wrapped in %)   |
| OrderBy           | findByAgeOrderByLastnameDesc            | … where x.age = ?1 order by x.lastname desc                  |
| Not               | findByLastnameNot                       | … where x.lastname <> ?1                                     |
| In                | findByAgeIn(Collection ages)            | … where x.age in ?1                                          |
| NotIn             | findByAgeNotIn(Collection age)          | … where x.age not in ?1                                      |
| TRUE              | findByActiveTrue()                      | … where x.active = true                                      |
| FALSE             | findByActiveFalse()                     | … where x.active = false                                     |
| IgnoreCase        | findByFirstnameIgnoreCase               | … where UPPER(x.firstame) = UPPER(?1)                        |

## 六、IO

![img](https://pic1.zhimg.com/80/v2-eb408ac849a679b09941be7ebd734768_720w.jpg)

## 代码生成工具的使用

gitlab 路径：http://172.16.10.197/team-web-plat/result-management/generator

源自开源项目：https://gitee.com/baomidou/mybatis-plus 原项目基于 mybatis，修改为 JPA+

queryDSL

---

## 一、SpringBoot

> 1）注册Bean对象

~~~java
@Configuration
public class AppConfig {
    @Bean
    public TransferService transferService() {
        return new TransferServiceImpl();
    }
}
~~~

> 2）