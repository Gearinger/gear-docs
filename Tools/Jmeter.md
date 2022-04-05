### 并发测试

#### 1、安装OpenApi Generate

> 此处选择 docker 安装线上版本 [openapitools/openapi-generator-online - Docker Image | Docker Hub](https://hub.docker.com/r/openapitools/openapi-generator-online/)

~~~sh
# 拉取镜像
docker pull openapitools/openapi-generator-online

# 运行容器
docker run -d -e GENERATOR_HOST=http://192.168.14.107 -p 9002:8080 openapitools/openapi-generator-online
~~~

#### 2、获取项目的接口文档（OpenAPI格式）

~~~json
{
  "swagger": "2.0",
  "info": {
    "description": "# NanSha Crop Statistics System RESTful APIs",
    "version": "1.0",
    "title": "NanSha Crop Statistics System RESTful API",
    "termsOfService": "http://www.xx.com/",
    "contact": {
      "name": "guoyingdong",
      "email": "guoyingdong@xa.cn"
    }
  },
  "host": "127.0.0.1:9005",
  "basePath": "/",
  "tags": [],
  "paths": {
    "/business/check-task/checkByTown": {
      "post": {
        ...
      }
      ...
    }
  }
}
~~~

#### 3、生成 jmeter 文件

访问 `jmeter` 在线接口文档 [localhost:9002/index.html](http://localhost:9002/index.html)

> （1）post请求：
> /api/gen/clients/{language}
> param 参数： language: jmeter
> 请求体参数：
> {
>   "spec":{
>
> ​	[OpenAPI.json 的内容]
>
>   }
> }
>
> 获取到返回值：
> {
>   code:"d40029be-eda6-4d62-b1ef-d05e2e91a72a"
>   link:"http://localhost:8080/api/gen/download/d40029be-eda6-4d62-b1ef-d05e2e91a72a"
> }
>
> （2）下载生成的数据
> 浏览器直接访问：http://localhost:9002/api/gen/download/{上一步获得的code}，自动下载zip文件
>
> 

#### 4、安装jmeter

（1）下载 https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.4.3.zip

（2）解压，运行 jmeter.bat（需要 JDK 环境）

#### 5、设置 jmeter 

（1）zip文件解压，jmeter 打开 DefaultApi.jmx 文件

（2）在 DefaultApi.csv 文件中填写相关请求参数

（3）定义 User Defined Variables 中 threads（等于接口并发量）

（4）运行测试（GUI只是用来方便设置和调试的，实际测试需要用命令）

~~~sh
# testplan/RedisLock.jmx 为测试计划文件路径
# testplan/result/result.txt 为测试结果文件路径
# testplan/webreport 为web报告保存路径
jmeter -n -t DefaultApi.jmx -l result.txt -e -o webreport
~~~



