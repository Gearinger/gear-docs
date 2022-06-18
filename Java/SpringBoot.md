## 一、环境配置

### 1、Maven

### 2、JDK

## 二、教程

### 1、简单示例

#### （1）项目创建

![image-20211208194310591](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211208-194855.png)

#### （2）全局依赖

```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
    </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
    </dependency>
</dependencies>
```

#### （3）组织结构

![image-20211208194923516](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211208-194925.png)

> 1、`springboot2-demo/pom.xml ` 配置所有全局依赖；
> 
> 2、config 文件夹内定义swagger2、全局异常捕捉、返回结果包装、跨域处理；

#### （4）Swagger2

- 配置依赖

> `springboot2-demo/config/pom.xml` 

```xml
<!-- swagger2-->
<dependencies>
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger2</artifactId>
        <version>2.9.2</version>
    </dependency>
    <!-- swagger2-UI-->
    <dependency>
        <groupId>io.springfox</groupId>
        <artifactId>springfox-swagger-ui</artifactId>
        <version>2.9.2</version>
    </dependency>
    <dependency>
        <groupId>com.github.xiaoymin</groupId>
        <artifactId>swagger-bootstrap-ui</artifactId>
        <version>1.9.6</version>
    </dependency>
</dependencies>
```

- 注入配置组件

```java
/**
 * Swagger的配置
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
@Configuration
@EnableSwagger2
public class SwaggerConfig extends WebMvcConfigurationSupport {
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .apis(RequestHandlerSelectors.withClassAnnotation(Api.class))
                .paths(PathSelectors.any())
                .build();
    }

    @Bean
    UiConfiguration uiConfig() {
        return UiConfigurationBuilder.builder()
                .deepLinking(true)
                .displayOperationId(false)
                .defaultModelsExpandDepth(1)
                .defaultModelExpandDepth(1)
                .defaultModelRendering(ModelRendering.EXAMPLE)
                .displayRequestDuration(false)
                .docExpansion(DocExpansion.NONE)
                .filter(false)
                .maxDisplayedTags(null)
                .operationsSorter(OperationsSorter.ALPHA)
                .showExtensions(false)
                .tagsSorter(TagsSorter.ALPHA)
                .supportedSubmitMethods(UiConfiguration.Constants.DEFAULT_SUBMIT_METHODS)
                .validatorUrl(null)
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("gear api")
                .description("gear api description")
                .termsOfServiceUrl("http://127.0.0.1:8009/")
                .contact(new Contact("gear","http://127.0.0.1","2661569419@qq.com"))
                .version("1.0")
                .build();
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("swagger-ui.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("doc.html").addResourceLocations("classpath:/META-INF/resources/");
        registry.addResourceHandler("/webjars/**").addResourceLocations("classpath:/META-INF/resources/webjars/");
    }
}
```

#### （5）返回结果包装

```java
/**
 * 返回结果定义
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
public class ResultBody<T> {
    /**
     * 响应代码
     */
    private String code;

    /**
     * 响应消息
     */
    private String message;

    /**
     * 响应结果
     */
    private T result;

    public ResultBody() {
    }

    /**
     * 结果
     *
     * @param errorInfo 错误信息
     * @return {@link  }
     */
    public ResultBody(BaseErrorInfoInterface errorInfo) {
        this.code = errorInfo.getResultCode();
        this.message = errorInfo.getResultMsg();
    }

    /**
     * 成功
     *
     * @return {@link ResultBody }
     */
    public static <T> ResultBody<T> success() {
        return success(null);
    }

    /**
     * 成功
     *
     * @param data 数据
     * @return {@link ResultBody }
     */
    public static <T> ResultBody<T> success(T data) {
        ResultBody<T> rb = new ResultBody<T>();
        rb.setCode(CommonEnum.SUCCESS.getResultCode());
        rb.setMessage(CommonEnum.SUCCESS.getResultMsg());
        rb.setResult(data);
        return rb;
    }

    /**
     * 失败
     */
    public static <T> ResultBody<T> error(BaseErrorInfoInterface errorInfo) {
        ResultBody<T> rb = new ResultBody<T>();
        rb.setCode(errorInfo.getResultCode());
        rb.setMessage(errorInfo.getResultMsg());
        rb.setResult(null);
        return rb;
    }

    /**
     * 失败
     */
    public static <T> ResultBody<T> error(String code, String message) {
        ResultBody<T> rb = new ResultBody<T>();
        rb.setCode(code);
        rb.setMessage(message);
        rb.setResult(null);
        return rb;
    }

    /**
     * 失败
     */
    public static <T> ResultBody<T> error(String message) {
        ResultBody<T> rb = new ResultBody<T>();
        rb.setCode("-1");
        rb.setMessage(message);
        rb.setResult(null);
        return rb;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getResult() {
        return result;
    }

    public void setResult(T result) {
        this.result = result;
    }

    @Override
    public String toString() {
        return JSONObject.toJSONString(this);
    }

}
```

#### （6）全局异常

> 定义接口 BaseErrorInfoInterface

```java
/**
 * 基本错误信息界面
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
public interface BaseErrorInfoInterface {
    /**
     * 获取的结果状态码
     *
     * @return {@link String }
     */
    String getResultCode();

    /**
     * 获取结果信息
     *
     * @return {@link String }
     */
    String getResultMsg();
}
```

> 包装 RuntimeException

```java
/**
 * 业务异常
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
public class BizException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    /**
     * 错误码
     */
    protected String errorCode;
    /**
     * 错误信息
     */
    protected String errorMsg;

    public BizException() {
        super();
    }

    public BizException(BaseErrorInfoInterface errorInfoInterface) {
        super(errorInfoInterface.getResultCode());
        this.errorCode = errorInfoInterface.getResultCode();
        this.errorMsg = errorInfoInterface.getResultMsg();
    }

    public BizException(BaseErrorInfoInterface errorInfoInterface, Throwable cause) {
        super(errorInfoInterface.getResultCode(), cause);
        this.errorCode = errorInfoInterface.getResultCode();
        this.errorMsg = errorInfoInterface.getResultMsg();
    }

    public BizException(String errorMsg) {
        super(errorMsg);
        this.errorMsg = errorMsg;
    }

    public BizException(String errorCode, String errorMsg) {
        super(errorCode);
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
    }

    public BizException(String errorCode, String errorMsg, Throwable cause) {
        super(errorCode, cause);
        this.errorCode = errorCode;
        this.errorMsg = errorMsg;
    }


    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    @Override
    public String getMessage() {
        return errorMsg;
    }

    @Override
    public Throwable fillInStackTrace() {
        return this;
    }

}
```

> 定义异常枚举

```java
/**
 * 常见的枚举
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
public enum CommonEnum implements BaseErrorInfoInterface {
    // 数据操作错误定义
    SUCCESS("200", "成功!"),
    BODY_NOT_MATCH("400", "请求的数据格式不符!"),
    SIGNATURE_NOT_MATCH("401", "请求的数字签名不匹配!"),
    NOT_FOUND("404", "未找到该资源!"),
    INTERNAL_SERVER_ERROR("500", "服务器内部错误!"),
    SERVER_BUSY("503", "服务器正忙，请稍后再试!");

    /**
     * 错误码
     */
    private final String resultCode;

    /**
     * 错误描述
     */
    private final String resultMsg;

    CommonEnum(String resultCode, String resultMsg) {
        this.resultCode = resultCode;
        this.resultMsg = resultMsg;
    }

    @Override
    public String getResultCode() {
        return resultCode;
    }

    @Override
    public String getResultMsg() {
        return resultMsg;
    }

}
```

> 全局异常处理

```java
/**
 * 全局异常处理
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
@ControllerAdvice
public class GlobalExceptionHandler {
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 处理自定义的业务异常
     *
     * @param req 要求的事情
     * @param e   e
     * @return {@link}
     */
    @ExceptionHandler(value = BizException.class)
    @ResponseBody
    public ResultBody bizExceptionHandler(HttpServletRequest req, BizException e) {
        logger.error("发生业务异常！原因是：{}", e.getErrorMsg());
        return ResultBody.error(e.getErrorCode(), e.getErrorMsg());
    }

    /**
     * 处理空指针的异常
     *
     * @param req 要求的事情
     * @param e   e
     * @return {@link}
     */
    @ExceptionHandler(value = NullPointerException.class)
    @ResponseBody
    public ResultBody exceptionHandler(HttpServletRequest req, NullPointerException e) {
        logger.error("发生空指针异常！原因是:", e);
        return ResultBody.error(CommonEnum.BODY_NOT_MATCH);
    }


    /**
     * 处理其他异常
     *
     * @param req 要求的事情
     * @param e   e
     * @return {@link}
     */
    @ExceptionHandler(value = Exception.class)
    @ResponseBody
    public ResultBody exceptionHandler(HttpServletRequest req, Exception e) {
        logger.error("未知异常！原因是:", e);
        return ResultBody.error(CommonEnum.INTERNAL_SERVER_ERROR);
    }
}
```

#### （7）全局跨域处理

```java
/**
 * 跨域处理（暂全部放行）
 * 安全的方式应采用对单个controller使用@CrossOrigin注解
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
@Configuration
public class Cors {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("*")
                        .allowCredentials(true)
                        .allowedMethods("GET", "POST", "DELETE", "PUT", "PATCH")
                        .maxAge(3600);
            }
        };
    }
}
```

#### （8）新建模块

![image-20211208194947575](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211208-194949.png)

> controller 必须使用@Api注解，因当前swagger配置的是用该注解扫描

```java
/**
 * 测试控制器
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
@Api(tags = "test")
@RestController
@RequestMapping("/test")
public class TestController {
    /**
     * 测试
     *
     * @return {@link String }
     */
    @RequestMapping(value = "/test1", method = RequestMethod.GET)
    public String test() {
        return "~~~~~~~~~~~~~~";
    }

    @RequestMapping(value = "/test2", method = RequestMethod.GET)
    public ResultBody testException() throws Exception {
        return ResultBody.success("Test Wrong!!!");
    }

    @GetMapping("/test3")
    public boolean testException3() {
        System.out.println("开始新增...");
        //如果姓名为空就手动抛出一个自定义的异常！
        throw new BizException("-1", "用户姓名不能为空！");
    }

    @GetMapping("/test4")
    public boolean testException4() {
        System.out.println("开始更新...");
        //这里故意造成一个空指针的异常，并且不进行处理
        String str = null;
        str.equals("111");
        return true;
    }

    @GetMapping("/test5")
    public boolean testException5() {
        System.out.println("开始删除...");
        //这里故意造成一个异常，并且不进行处理
        Integer.parseInt("abc123");
        return true;
    }
}
```

> 新建模块启动程序需指定扫描组件的位置 scanBasePackages，使config模块被扫描到；

```java
/**
 * 测试演示应用程序
 *
 * @author guoyd
 * @version 1.0.0
 * @date 2021/01/25
 */
@SpringBootApplication(scanBasePackages = {"com.gear.config", "com.gear.testdemo"})
@EnableSwagger2
public class TestDemoApplication {

    @Autowired
    ServerProperties serverProperties;

    public static void main(String[] args) {
        SpringApplication.run(TestDemoApplication.class, args);
        System.out.println("----------程序开始运行----------");
    }
}
```

### 2、自定义配置

#### （1）@ConfigurationProperties 绑定配置+ @Configration 注入容器

```JAVA
// 标记使之被扫描到，将当前class转为bean放置到容器中，以便后续获取使用（可换成@Component）
@Configration
// 与配置文件绑定
@ConfigurationProperties(prefix="test")
// lombok 添加get、set方法
@Data
public class TestConfig{
    private String name;
}
```

#### （2）@Value 绑定单个属性的配置+ @Configration 注入容器

```JAVA
// 标记使之被扫描到，将当前class转为bean放置到容器中，以便后续获取使用（可换成@Component）
@Configration
public class TestConfig{
    @Value("${test.testConfig.name}")
    private String name;
}
```

#### （3）@ConfigurationProperties 绑定配置+ @EnableConfigurationProperties 注入容器

```JAVA
// 与配置文件绑定
@ConfigurationProperties(prefix="test")
// lombok 添加get、set方法
@Data
public class TestConfig{
    private String name;
}

// 标记使之被扫描到，将当前class转为bean放置到容器中，以便后续获取使用（可换成@Component）
@Configration
// 实例化当前类的同时，将 TestConfig 注入容器供后续获取使用
@EnableConfigurationProperties(TestConfig.Class)
public class Test2{
    ……
}
```

#### （4）@ConfigurationProperties 绑定配置+ @Bean 注入容器

```JAVA
// 与配置文件绑定
@ConfigurationProperties(prefix="test")
// lombok 添加get、set方法
@Data
public class TestConfig{
    private String name;
}

// 标记使之被扫描到，将当前class转为bean放置到容器中，以便后续获取使用（可换成@Component）
@Configration
public class Test2{
    // 将 TestConfig 注入容器
    @Bean
    public TestConfig testConfig(){
        return new TestConfig()
    }
}
```

### 3、常用注解

- @SpringBootApplication

> @SpringBootApplication 注解等价于以默认属性使用 @Configuration ， @EnableAutoConfiguration 和 @ComponentScan 

- @Configration

> 将当前类标记为一个组件，可被@ComponentScan扫描到注入容器中

- @Import

> 当前类被扫描到时，先注入目标类
> 
> ```JAVA
> @Import(Demo.Class)
> public class Test{
> 
> }
> ```

- @AutoWired/@Resource

> @Resource的作用相当于@Autowired，只不过@Autowired按byType自动注入，而@Resource默认按 byName自动注入

- @Qualifier

> 当存在多个同类型bean时，配合@AutoWired，指明获取特定bean名称的实例
> 
> ```JAVA
> @Component
> public class FooService {
>     @Autowired
>     @Qualifier("fooFormatter")
>     private Formatter formatter;
> 
>     //todo 
> }
> ```

- @Component、@Configration、@Service、@Controller、@RestController

> 标记为可被被扫描的控件

### 4、请求处理

### 5、拦截器（HandlerInterceptor）

#### （1）自定义实现 HandlerInterceptor

```JAVA
public class AdminInterceptor implements  HandlerInterceptor {

    /**
     * 在请求处理之前进行调用（Controller方法调用之前）
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        try {
            //统一拦截（查询当前session是否存在user）(这里user会在每次登陆成功后，写入session)
            User user=(User)request.getSession().getAttribute("USER");
            if(user!=null){
                return true;    // 放行
            }
            response.sendRedirect(request.getContextPath()+"你的登陆页地址");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;    // 拦截
    }

    /**
     * 请求处理之后进行调用，但是在视图被渲染之前（Controller方法调用之后）
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) {

    }

    /**
     * 在整个请求结束之后被调用，也就是在DispatcherServlet 渲染了对应的视图之后执行（主要是用于进行资源清理工作）
     */
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {

    }

}
```

#### （2）注册自定义的拦截器

```JAVA
@Configuration
public class LoginConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // 注册TestInterceptor拦截器
        InterceptorRegistration registration = registry.addInterceptor(new AdminInterceptor());

        // 拦截所有路径
        registration.addPathPatterns("/**");                      

        // 添加放行的路径
        registration.excludePathPatterns(                         
            "你的登陆路径",            //登录
            "/**/*.html",            //html静态资源
            "/**/*.js",              //js静态资源
            "/**/*.css",             //css静态资源
            "/**/*.woff",
            "/**/*.ttf"
        );    
    }
}
```

### 6、过滤器（Filter）

实现javax.Servlet.Filter接口，并重写接口中定义的三个方法

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

// 必须添加注解，springmvc通过web.xml配置
@Component
public class TimeFilter implements Filter {
  private static final Logger LOG = LoggerFactory.getLogger(TimeFilter.class);

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
    LOG.info("初始化过滤器：{}", filterConfig.getFilterName());
  }

  @Override
  public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
    LOG.info("start to doFilter");
    long startTime = System.currentTimeMillis();
    chain.doFilter(request, response);
    long endTime = System.currentTimeMillis();
    LOG.info("the request of {} consumes {}ms.", getUrlFrom(request), (endTime - startTime));
    LOG.info("end to doFilter");
  }

  @Override
  public void destroy() {
    LOG.info("销毁过滤器");
  }

  private String getUrlFrom(ServletRequest servletRequest){
    if (servletRequest instanceof HttpServletRequest){
      return ((HttpServletRequest) servletRequest).getRequestURL().toString();
    }
    return "";
  }
}
```

### 7、单元测试

#### （1）注解

| 注解                                       | 修饰对象       | 作用                             |
| ---------------------------------------- | ---------- | ------------------------------ |
| @SpringBootTest                          | class      | 标识为测试用例                        |
| @DisplayName                             | class、方法函数 | 别名                             |
| @Test                                    | 方法函数       | 测试方法                           |
| @Disable                                 | 方法函数       | 使测试方法不运行                       |
| @TimeOut(value=1, unit=TimeUnit.Seconds) | 方法函数       | 标定测试方法的限制时间1s，超时则失败报错          |
| @RepeatedTest(5)                         | 方法函数       | 运行五次该测试方法                      |
| @BeforeAll                               | 方法函数       | 所有测试方法运行前，先运行此方法（一次）           |
| @BeforeEach                              | 方法函数       | 每个测试方法运行前，都运行此方法（运行次数等于测试方法次数） |
| @AfterAll                                | 方法函数       | 所有测试方法运行后，运行此方法（一次）            |
| @AfterEach                               | 方法函数       | 每个测试方法运行前，都运行此方法（运行次数等于测试方法次数） |

#### （2）断言

| 方法                                    | 作用                               |
| ------------------------------------- | -------------------------------- |
| assertArrayEquals(expecteds, actuals) | 查看两个数组是否相等。                      |
| assertEquals(expected, actual)        | 查看两个对象是否相等。类似于字符串比较使用的equals()方法 |
| assertNotEquals(first, second)        | 查看两个对象是否不相等。                     |
| assertNull(object)                    | 查看对象是否为空。                        |
| assertNotNull(object)                 | 查看对象是否不为空。                       |
| assertSame(expected, actual)          | 查看两个对象的引用是否相等。类似于使用“==”比较两个对象    |
| assertNotSame(unexpected, actual)     | 查看两个对象的引用是否不相等。类似于使用“!=”比较两个对象   |
| assertTrue(condition)                 | 查看运行结果是否为true。                   |
| assertFalse(condition)                | 查看运行结果是否为false。                  |
| assertThat(actual, matcher)           | 查看实际值是否满足指定的条件                   |
| fail()                                | 让测试失败                            |

#### （3）前置条件

```JAVA
@DisplayName("测试")
@Test
void Test(){
    assumptions.assumpFalse(false);    // false 满足条件，继续执行后面的内容
    assumptions.assumpTrue(false);    // false 不满足条件，不执行后面的内容，当前测试方法将被标记为跳过测试
    ...
}
```

#### （4）嵌套测试

```JAVA
// 外层声明的变量，会先在外层跑完所有测试，再进去内层跑测试。
// 所以,外层修改变量值，会影响内层，但是内层修改变量值不会影响外层
@SpringbootTest
@DisplayName("测试")
class Test{

    // 变量
    Stack<Object> stack;

    @Test
    void CheckNull(){
        // 内层对 stack 的操作不影响外层，这里 stack 测试结果是null。但是外层对 stack 的操作会影响内层的调用
        assertNotNull(stack);
    }

    @Nested
    @DisplayName("测试2")
    class Test2{
        @BeforeAll
        void Init(){
            // 不影响外层的测试方法
            stack = new Stack<Object>();
        }
    }
}
```

#### （5）参数化测试

@ValueSource()

```JAVA
@Test
// 针对每个元素，都执行一遍测试方法
@VaueSource(ints = {1,2,3,4,5})
void Test(int i){
    system.out.println(i);
}
```

@MethodSource

```JAVA
@Test
// 针对每个元素，都执行一遍测试方法
@MethodSource("Method")
void Test(string str){
    system.out.println(str);
}

Static Stream<String> Method(){
    return Stream.of("A","B","C")
}
```

### 8、监控

#### （1）Spring Boot Actuator

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

```yaml
management:
  endpoints:
    enabled-by-default: true
#启动所有端点
  web:
    exposure:
      include: *
#自定义管理端点路径
#management.endpoints.web.base-path=/manage
```

#### （2）可视化界面 Spring Boot Admin Server

- 创建新的项目用于服务端监控

```XML
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-server</artifactId>
    <version>2.1.0</version>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

```JAVA
@SpringBootApplication
@EnableAdminServer    启动监控
public class AdminServerApplication {

    public static void main(String[] args) {
        SpringApplication.run( AdminServerApplication.class, args );
    }

}
```

```YAML
spring:
  application:
    name: admin-server
server:
  port: 8888
```

- 配置被监控的客户端

```xml
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-client</artifactId>
    <version>2.1.0</version>
</dependency>
```

```YAML
spring:
  application:
    name: admin-client
  boot:
    admin:
      client:
        url: http://localhost:8888
server:
  port: 8080

management:
  endpoints:
    # 放行所有web接口
    web:
      exposure:
        include: '*'
  endpoint:
    health:
      show-details: ALWAYS
```

## 三、常用Jar包整合

### 1、PostgreSQL

### 2、Mybatis-Plus

#### 初始化

#### 代码生成器

#### ID雪花算法

#### 通用Service

```java
// Save SaveOrUpdate Remove Update Get List Page Count Chain ...
public class EmployeeImplService extends ServeceImpl<EmployeeMapper, Employee> impletments Employee{

}
```

#### Mapper

```java
// Insert Delete Update Select
```

#### 条件构造器

```java
@AutoWired
EmployeeService employeeService;

// 普通QueryWrapper
public Collection<Employee> test(){
    QueryWrapper<Employee> wrapper = new QueryWrapper<>();
    wrapper.select("name", "gender")
        .eq("gender", "man");
    return employeeService.list(wrapper);
}

// 普通UpdateWrapper
public Boolean test(){
    QueryWrapper<Employee> wrapper = new QueryWrapper<>();
    return wrapper.set("name", "Tom")
        .eq("id", "0");
}

// lambda wrapper
public Collection<Employee> test2(){
    QueryWrapper<Employee> wrapper = new QueryWrapper<>();
    wrapper.lambda()
        .select(Employee::name, Employee::gender)
        .eq(Employee::gender, "man");
    return employeeService.list(wrapper);
}
```

### 3、Swagger2

### 4、Knife4j

### 5、Redis 缓存

### 6、ElasticSearch

### 7、GeoTools

> 尚硅谷SpringBoot2文档：[SpringBoot2核心技术与响应式编程 · 语雀 (yuque.com)](https://www.yuque.com/atguigu/springboot)

## 四、知识点

### 1、过滤器和拦截器的主要区别

过滤器主要作用

> 1) Authentication Filters, 即用户访问权限过滤
> 
> 2) Logging and Auditing Filters, 日志过滤，可以记录特殊用户的特殊请求的记录等
> 
> 3) Image conversion Filters
> 
> 4) Data compression Filters
> 
> 5) Encryption Filters
> 
> 6) Tokenizing Filters
> 
> 7) Filters that trigger resource access events
> 
> 8) XSL/T filters
> 
> 9) Mime-type chain Filter

拦截器主要作用

> 1) **日志记录：**记录请求信息的日志，以便进行信息监控、信息统计、计算PV（Page View）等
> 
> 2) **权限检查：**如登录检测，进入处理器检测检测是否登录
> 
> 3) **性能监控：**通过拦截器在进入处理器之前记录开始时间，在处理完后记录结束时间，从而得到该请求的处理时间。（反向代理，如apache也可以自动记录）；
> 
> 4) **通用行为：**读取cookie得到用户信息并将用户对象放入请求，从而方便后续流程使用，还有如提取Locale、Theme信息等，只要是多个处理器都需要的即可使用拦截器实现。

## 五、Issue

### 1、中文乱码问题

- 原因

项目中引入了`WebMvcConfigurationSupport`。

由于添加Swagger2的配置引入了`WebMvcConfigurationSupport`

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig extends WebMvcConfigurationSupport {
    ……

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        ……
    }
}
```

- 解决方式

删除addResourceHandlers方法的重写，修改为

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    ……
}
```

### 2、跨域配置正则问题

- 原因

跨域配置错误

错误示例：`.allowedOrigin("*")`

- 解决方式

正确示例：`.allowedOriginPatterns("*")`

```java
@Configuration
public class Cors {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOriginPatterns("*")
                        .allowCredentials(true)
                        .allowedMethods("GET", "POST", "DELETE", "PUT", "PATCH")
                        .maxAge(3600);
            }
        };
    }
}
```

### 3、引入SwaggerBootstrapUI后，Swagger界面不显示的问题

- 原因

由于之前设置了启用增强功能

![image-20210220135908055](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211206-153614.png)

- 解决方式
  
  - 方式一
  
  Application的类上添加`@EnableSwaggerBootstrapUI`注解。
  
  ```java
  @SpringBootApplication
  @EnableSwagger2
  @EnableSwaggerBootstrapUI
  public class DemoApplication {
      public static void main(String[] args) {
          SpringApplication.run(DemoApplication.class, args);
      }
  }
  ```
  
  - 方式二
  
  找到本地Maven仓库的SwaggerBootstrapUI包进行删除，再重新拉取。

### 4、spring.jackson.date-format 失效原因及解决方式

- 问题

`spring.jackson.date-format`失效，导致序列化获取的时间是时间戳格式，不是常规使用的格式化的`json`

配置文件内容：

```yaml
spring:
  jackson:
    date-format: yyyy-MM-dd HH:mm:ss
    time-zone: GMT+8
    serialization:
      write-dates-as-timestamps: false
```

- 原因

在项目中继承了 `WebMvcConfigurationSupport `这个类。一般是因为`swagger`的`bean`配置中有继承，如下：

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig implements WebMvcConfigurationSupport {
    @Bean
    public Docket createRestApi() {
        ...
```

- 解决方式

修改为实现`WebMvcConfigurer`接口，如下：

```java
@Configuration
@EnableSwagger2
public class SwaggerConfig implements WebMvcConfigurer {
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                ...
```

### 5、RestTemplate的使用

> 高并发情况下，不适合使用单例模式（包括@Bean注入）

```java
// 创建调用 https 接口的 RestTemplate
public RestTemplate buildRestTemplate() throws KeyStoreException, NoSuchAlgorithmException, KeyManagementException {
  SSLContext sslContext = new SSLContextBuilder().loadTrustMaterial(null, new TrustStrategy() {
    @Override
    public boolean isTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {
      return true;
    }
  }).build();

  SSLConnectionSocketFactory csf = new SSLConnectionSocketFactory(sslContext,
                                                                  new String[]{"TLSv1"},
                                                                  null,
                                                                 NoopHostnameVerifier.INSTANCE);

  CloseableHttpClient httpClient = HttpClients.custom()
    .setSSLSocketFactory(csf)
    .build();

  HttpComponentsClientHttpRequestFactory requestFactory =
    new HttpComponentsClientHttpRequestFactory();

  requestFactory.setHttpClient(httpClient);
  RestTemplate restTemplate = new RestTemplate(requestFactory);
  return restTemplate;
}


// 使用 RestTemplate
// 注意必须使用 MultiValueMap 接收参数，restTemplate 无法解析 hashmap 的内容 
public static void main(){
  HttpHeaders headers = new HttpHeaders();
  headers.add("Content-Type", "application/x-www-form-urlencoded");
  headers.add("Authorization", "");

  MultiValueMap requestBody = new LinkedMultiValueMap();
  requestBody.add("username", userName);
  requestBody.add("password", password);

  HttpEntity<Map<String, Object>> httpEntity = new HttpEntity<>(requestBody, headers);

  try {
    ResponseEntity<User> userResponseEntity = restTemplate.postForEntity(LOGIN_URL, httpEntity, User.class);
    return userResponseEntity.getBody();
  } catch (Exception e){
    e.printStackTrace();
  }
}
```

### 6、Maven 依赖冲突

使用`Maven Helper`插件可以直接查看冲突。

[Maven Helper 安装使用_dhfzhishi的专栏-CSDN博客_mavenhelper使用](https://blog.csdn.net/dhfzhishi/article/details/81952760)

### 7、关于 Docker 打包

当前主要使用的 docker 打包插件有三种。

- io.fabric8 的 docker-maven-plugin
- com.spotify 的 docker-maven-plugin
- spring官方（org.springframework.boot）的 spring-boot-maven-plugin

| 名称          | 优势                               | 劣势                                            | 补充                    |
| ----------- | -------------------------------- | --------------------------------------------- | --------------------- |
| io.fabric8  | 基本可以进行build、push、run、stop等所有容器操作 | 在配置时，无法将pom文件内的变量传递到dockfile文件内               | 主要使用pom配置             |
| com.spotify | 功能相较少一些                          | pom文件中，可通过Resources节点将pom文件内的变量传递到dockfile文件内 |                       |
| spring官方    | 基本可以进行所有容器操作                     | 镜像源只能用官方的，且国内难下载                              | 版本升级到SpringBoot 2.4.0 |

#### （1）io.fabric8

参考：https://mp.weixin.qq.com/s/3X6vVdWmjmWCyiLm35jpVw

```xml
<build>
  <plugins>
    <plugin>
      <groupId>io.fabric8</groupId>
      <artifactId>docker-maven-plugin</artifactId>
      <version>0.33.0</version>
      <configuration>
        <!-- Docker 远程管理地址-->
        <dockerHost>http://192.168.3.101:2375</dockerHost>
        <!-- Docker 推送镜像仓库地址-->
        <pushRegistry>http://192.168.3.101:5000</pushRegistry>
        <images>
          <image>
            <!--由于推送到私有镜像仓库，镜像名需要添加仓库地址-->
            <name>192.168.3.101:5000/mall-tiny/${project.name}:${project.version}</name>
            <!--定义镜像构建行为-->
            <build>
              <!--定义基础镜像-->
              <from>java:8</from>
              <args>
                <JAR_FILE>${project.build.finalName}.jar</JAR_FILE>
              </args>
              <!--定义哪些文件拷贝到容器中-->
              <assembly>
                <!--定义拷贝到容器的目录-->
                <targetDir>/</targetDir>
                <!--只拷贝生成的jar包-->
                <descriptorRef>artifact</descriptorRef>
              </assembly>
              <!--定义容器启动命令-->
              <entryPoint>["java", "-jar","/${project.build.finalName}.jar"]</entryPoint>
              <!--定义维护者-->
              <maintainer>macrozheng</maintainer>
            </build>
          </image>
        </images>
      </configuration>
    </plugin>
  </plugins>
</build>
```

需构建镜像时，idea 中可点击 maven 管理栏中的 package，再点击 docker:build

或者，使用以下命令

```sh
mvn package docker:build
```

> 也可采用 dockerfile 的方式
> 
> ```dockerfile
> # 该镜像需要依赖的基础镜像
> FROM java:8
> # 将当前maven目录生成的文件复制到docker容器的/目录下
> COPY maven /
> # 声明服务运行在8080端口
> EXPOSE 8080
> # 指定docker容器启动时运行jar包
> ENTRYPOINT ["java", "-jar","/mall-tiny-fabric-0.0.1-SNAPSHOT.jar"]
> # 指定维护者的名字
> MAINTAINER macrozheng
> ```
> 
> `<build> ` 节点配置替换为如下内容
> 
> ```xml
> <build>
>   <dockerFileDir>${project.basedir}</dockerFileDir>
> </build>
> ```

#### （2）com.spotify

- 仅 pom 文件中配置

```xml
<build>
  <plugins>
    <plugin>
      <groupId>com.spotify</groupId>
      <artifactId>docker-maven-plugin</artifactId>
      <version>1.0.0</version>
      <configuration>
        <imageName>mavendemo</imageName>
        <baseImage>java</baseImage>
        <maintainer>docker_maven docker_maven@email.com</maintainer>
        <workdir>/ROOT</workdir>
        <cmd>["java", "-version"]</cmd>
        <entryPoint>["java", "-jar", "${project.build.finalName}.jar"]</entryPoint>
        <!-- 这里是复制 jar 包到 docker 容器指定目录配置 -->
        <resources>
          <resource>
            <targetPath>/ROOT</targetPath>
            <directory>${project.build.directory}</directory>
            <include>${project.build.finalName}.jar</include>
          </resource>
        </resources>
      </configuration>
    </plugin>
  </plugins>
</build>
```

- 配合 dockerfile 文件配置

```xml
<build>
  <plugins>
    <plugin>
      <groupId>com.spotify</groupId>
      <artifactId>docker-maven-plugin</artifactId>
      <version>1.0.0</version>
      <configuration>
        <imageName>mavendemo</imageName>
        <dockerDirectory>${basedir}/docker</dockerDirectory> <!-- 指定 Dockerfile 路径-->
        <!-- 这里是复制 jar 包到 docker 容器指定目录配置，也可以写到 Docokerfile 中 -->
        <resources>
          <resource>
            <targetPath>/ROOT</targetPath>
            <directory>${project.build.directory}</directory>
            <include>${project.build.finalName}.jar</include>
          </resource>
        </resources>
      </configuration>
    </plugin>   
  </plugins>
</build>
```

#### （3）spring-boot-maven-plugin

参考：[还在使用第三方Docker插件？SpringBoot官方插件真香！ - Document (macrozheng.com)](http://www.macrozheng.com/#/reference/springboot_docker_plugin)

```xml
<plugin>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-maven-plugin</artifactId>
  <configuration>
    <image>
      <!--配置镜像名称-->
      <name>192.168.3.101:5000/mall-tiny/${project.name}:${project.version}</name>
      <!--镜像打包完成后自动推送到镜像仓库-->
      <publish>true</publish>
    </image>
    <docker>
      <!--Docker远程管理地址-->
      <host>http://192.168.3.101:2375</host>
      <!--不使用TLS访问-->
      <tlsVerify>false</tlsVerify>
      <!--Docker推送镜像仓库配置-->
      <publishRegistry>
        <!--推送镜像仓库用户名-->
        <username>test</username>
        <!--推送镜像仓库密码-->
        <password>test</password>
        <!--推送镜像仓库地址-->
        <url>http://192.168.3.101:5000</url>
      </publishRegistry>
    </docker>
  </configuration>
</plugin>
```

构建时，idea中直接双击SpringBoot插件的`build-image`

或使用以下命令

```sh
mvn spring-boot:build-image
```

### 8、Linux 下部署 jar 包

start.sh

```sh
#!/bin/sh
nohup java -jar -Xms256m -Xmx512m  xxxxxxxx-1.0-SNAPSHOT.jar > ./output.log &
echo $! > ./output.pid
```

stop.sh

```sh
#!/bin/bash
PID=$(cat ./output.pid)
kill -9 $PID
```

### 9、文件二进制流下载

```java
@PostMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
@ApiOperation("下载文件")
public void download(@RequestParam String regionCode) {
  Util.fileStreamToResponse(fillePath);
}
```

```java
public static void fileStreamToResponse(String filePath) throws IOException {
  File file = new File(filePath);
  String fileName = file.getName();
  // 设置返回内容
  ServletRequestAttributes requestAttributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
  HttpServletResponse response = requestAttributes.getResponse();
  // 设置信息给客户端不解析
  String type = new MimetypesFileTypeMap().getContentType(filePath);
  // 设置contenttype，即告诉客户端所发送的数据属于什么类型
  response.setHeader("Content-type", type);
  response.setCharacterEncoding("utf-8");
  // 设置扩展头，当Content-Type 的类型为要下载的类型时 , 这个信息头会告诉浏览器这个文件的名字和类型。
  response.setHeader("Content-Disposition", "attachment;filename=" + java.net.URLEncoder.encode(fileName, "UTF-8"));
  try (OutputStream outputStream = response.getOutputStream()) {
    // 读取filename
    try (BufferedInputStream inputStream = new BufferedInputStream(new FileInputStream(filePath))) {
      byte[] buffer = new byte[1024];
      int length = -1;
      while ((length = inputStream.read(buffer)) != -1) {
        outputStream.write(buffer, 0, length);
      }
    }
  }
}
```

### 10 、跨域问题

常规跨域配置

```java
@Configuration
public class GlobalCorsConfig {
    @Bean
    public CorsFilter corsFilter() {
        //1. 添加 CORS配置信息
        CorsConfiguration config = new CorsConfiguration();
        //放行哪些原始域
        config.addAllowedOrigin("*");
        //是否发送 Cookie
        config.setAllowCredentials(true);
        //放行哪些请求方式
        config.addAllowedMethod("*");
        //放行哪些原始请求头部信息
        config.addAllowedHeader("*");
        //暴露哪些头部信息
        config.addExposedHeader("*");
        //2. 添加映射路径
        UrlBasedCorsConfigurationSource corsConfigurationSource = new UrlBasedCorsConfigurationSource();
        corsConfigurationSource.registerCorsConfiguration("/**",config);
        //3. 返回新的CorsFilter
        return new CorsFilter(corsConfigurationSource);
    }
}
```

> 例外：`SpringSecurity` 的环境下，需要针对 `SpringSecurity` 单独配置 `WebSecurityConfigurerAdapter`
> 
> ```java
> // SpringSecurity 配置
> @Configuration
> @EnableWebSecurity
> @EnableGlobalMethodSecurity(prePostEnabled = true)
> public class SecurityConfig extends WebSecurityConfigurerAdapter {
> 
>     ...
> 
>     @Bean
>     CorsConfigurationSource corsConfigurationSource(){
>         CorsConfiguration configuration = new CorsConfiguration();
>         // 允许从百度站点跨域
>         configuration.addAllowedOriginPattern("*");
>         configuration.addAllowedMethod("*");
>         configuration.addAllowedHeader("*");
> 
>         UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
>         //对所有URL生效
>         source.registerCorsConfiguration("/**", configuration);
>         return source;
>     }
> 
>     @Override
>     protected void configure(HttpSecurity httpSecurity) throws Exception {
>         httpSecurity
>                 .csrf().disable()
>                 // 基于token，所以不需要session
>                 .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS).and()
>                 .authorizeRequests()
>                 // 对于获取token的rest api要允许匿名访问
>                 .antMatchers("/**").permitAll()
>                 ...
>                 // 除上面外的所有请求全部需要鉴权认证
>                 .anyRequest().authenticated();
>         httpSecurity.addFilterBefore(jwtAuthenticationTokenFilter(), UsernamePasswordAuthenticationFilter.class);
>         // 禁用缓存
>         httpSecurity.headers().cacheControl();
>         // 异常返回给前端
>         httpSecurity.exceptionHandling().authenticationEntryPoint(authenticationEntryPointHandler());
>         httpSecurity.exceptionHandling().accessDeniedHandler(restfulAccessDeniedHandler());
> 
>         httpSecurity.formLogin();
>         httpSecurity.logout();
>         // 开启跨域
>         httpSecurity.cors();
>     }
> }
> ```
