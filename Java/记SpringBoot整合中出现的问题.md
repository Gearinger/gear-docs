### 1、中文乱码问题

- 原因

项目中引入了`WebMvcConfigurationSupport`。

由于添加Swagger2的配置引入了`WebMvcConfigurationSupport`

~~~java
@Configuration
@EnableSwagger2
public class SwaggerConfig extends WebMvcConfigurationSupport {
    ……

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        ……
    }
}
~~~

- 解决方式

删除addResourceHandlers方法的重写，修改为

~~~java
@Configuration
@EnableSwagger2
public class SwaggerConfig {
    ……
}
~~~



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

![image-20210220135908055](https://i.loli.net/2021/02/20/uJakR5oYm7POVHS.png)

- 解决方式

  - 方式一

  Application的类上添加`@EnableSwaggerBootstrapUI`注解。

  ~~~java
  @SpringBootApplication
  @EnableSwagger2
  @EnableSwaggerBootstrapUI
  public class DemoApplication {
      public static void main(String[] args) {
          SpringApplication.run(DemoApplication.class, args);
      }
  }
  ~~~

  - 方式二

  找到本地Maven仓库的SwaggerBootstrapUI包进行删除，再重新拉取。