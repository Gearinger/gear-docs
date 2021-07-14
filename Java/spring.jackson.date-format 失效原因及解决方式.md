# spring.jackson.date-format 失效原因及解决方式

## 问题

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

## 原因

在项目中继承了 `WebMvcConfigurationSupport `这个类。一般是因为`swagger`的`bean`配置中有继承，如下：

~~~java
@Configuration
@EnableSwagger2
public class SwaggerConfig implements WebMvcConfigurationSupport {
    @Bean
    public Docket createRestApi() {
        ...
~~~

## 解决方式

修改为实现`WebMvcConfigurer`接口，如下：

~~~java
@Configuration
@EnableSwagger2
public class SwaggerConfig implements WebMvcConfigurer {
    @Bean
    public Docket createRestApi() {
        return new Docket(DocumentationType.SWAGGER_2)
                ...
~~~

