# SpringBoot Data Jpa

## 一、依赖引入

~~~xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
    </dependency>

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>

    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
    </dependency>

    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.18</version>
    </dependency>
</dependencies>
~~~

## 二、配置项

~~~yaml
spring:
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: root
    password: 8e758bh98bt98rb9g
    url: jdbc:mysql://111.229.255.253:3306/test?allowMultiQueries=true&useUnicode=true&characterEncoding=UTF-8&zeroDateTimeBehavior=CONVERT_TO_NULL&serverTimezone=UTC&useSSL=true

  jpa:
    show-sql: true
    generate-ddl: true
    hibernate:
      ddl-auto: update
      naming:
        physical-strategy: org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl
    database: mysql
~~~

## 三、注解

~~~java
// 数据库表实例
@Entity

// 数据库表名
@Table(name = "business_user")

// 主键
@Id
// 主键生成策略
// 针对Mysql，对于Oracle需使用 Serialization
@GeneratedValue(Strategy = GenerationType.IDENTITY)

// 字段名
@Column(name = "user_name")

// 多表关联
@OneToOne
@OneToMany
@ManyToOne
@ManyToMany
@JoinTable

~~~



## 四、示例代码

### 1、简单示例

~~~java
// CrudRepository

// entity类
@Data
@Entity
@Table(name = "user") //此处可省略，自动关联表名为类名称
public class User(){
    @Id
    @GenerateType(……)
    private Long id;
    
    @Column(name = "name")
    private String name;
    
    ……
}

// dao 层
public interface UserRepository extend CrudRepository<User, Long>(){
    
} 

// service 层
@Service
public class UserService(){
    @AutoWired // 或者@Resource。resource优先使用名称，后采用类型；autowired采用类型
    UserRepository userRepository;
    
    public void testMethod(Long id){
        // 查询所有
        userRepository.findAll();
        
        // 保存。User有id，则会根据id进行更新，无对应记录则新增；User没有设置id的话，一定是新增
        User user = new User();
        userRepository.save(user);
        
        // 删除
        user.setId(1);
        userRepository.delete(user);
    }
}


~~~



### 2、常用 Repository

> JpaRepository

~~~java

~~~

> JpaSpecialRepository



### 3、DSL



### 4、多表联查

#### 1）一对多

#### 2）多对一

#### 3）多对多



### 5、事务Transaction