# SpringBoot2-Demo

## 一、项目创建

![image-20210128100425071](https://i.loli.net/2021/01/28/RXdLQxCNe5oA1Om.png)

## 二、依赖

- 全局依赖

~~~xml
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
~~~

## 三、配置全局处理

- 组织结构

![image-20210128102834846](https://i.loli.net/2021/01/28/QXGErtjTFZxlB2O.png)

> 1、`springboot2-demo/pom.xml ` 配置所有全局依赖；
>
> 2、config 文件夹内定义swagger2、全局异常捕捉、返回结果包装、跨域处理；

- Swagger2

  - 配置依赖

  > `springboot2-demo/config/pom.xml` 

  ```xml
  <!-- swagger2-->
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

- 返回结果包装

~~~java
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
~~~

- 全局异常

> 定义接口 BaseErrorInfoInterface

~~~java
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
~~~

> 包装 RuntimeException

~~~java
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
~~~

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

~~~java
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
     * @return {@link ResultBody }
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
     * @return {@link ResultBody }
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
     * @return {@link ResultBody }
     */
    @ExceptionHandler(value = Exception.class)
    @ResponseBody
    public ResultBody exceptionHandler(HttpServletRequest req, Exception e) {
        logger.error("未知异常！原因是:", e);
        return ResultBody.error(CommonEnum.INTERNAL_SERVER_ERROR);
    }
}
~~~

- 全局跨域处理

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

## 四、新建模块

![image-20210128102910202](https://i.loli.net/2021/01/28/8ZTOFs7DXGCJbNv.png)

> controller 必须使用@Api注解，因当前swagger配置的是用该注解扫描

~~~java
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
~~~

> 新建模块启动程序需指定扫描组件的位置 scanBasePackages，使config模块被扫描到；

~~~java
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
~~~

