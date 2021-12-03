## 一、日志

---

### 常见的请求方式

| 请求方式| 说明 |
| :----------: | :------: |
| GET | 查 |
| POST | 改（增、删、改） |
| DELETE | 删 |
| PUT | 增 |



### OWIN（KATANA）{#1}

### InfluxData.Net（时序数据库）

> InfluxDB（时序数据库），常用的一种使用场景：监控数据统计。每毫秒记录一下电脑内存的使用情况，然后就可以根据统计的数据，利用图形化界面（InfluxDB V1一般配合Grafana）制作内存使用情况的折线图；

> 可以理解为按时间记录一些数据（常用的监控数据、埋点统计数据等），[然后](#1)制作图表做统计；



### 根据Owin创建WebAPI

- 创建Console App
- nuget安装Microsoft.OWIN
- 添加-Startup
- 编辑startup，编辑program，根据提示添加引用或安装类库
- 添加-app.mainfest，编辑配置app.mainfest以管理员运行项目
- 配置config
- 创建其他api项目





---

## 二、问题

针对.net core中post类型的api注意的地方(前提是Controller上加[ApiController]特性)。默认是这个。

1、如果客户端Content-Type是application/json，  api接口如果是用单个对象做参数的时候，加或者不加[FromBody]都可以正常解析参数，但是接口是用对象列表做参数时候，则必须加[FromBody]，否则读取不到参数。

2、如果客户端Content-Type不是application/json，api接口必须加[FromBody]，否则客户端调用接口会报400错误。

3、如果加上[FromBody]，客户端Content-Type不是application/json，接口会报400错误。

