## swagger / sosoapi / rap2 / postman

> 常规流程：后端提供API文档→前后端各自实现→联调测试

### swagger

> 主要面向开发
>
> 优点：
>
> - 可在代码编写时写入文档注释，自动生成接口文档
> - Swagger 包含了 SwaggerEditor，它是使用 yaml 语言的 Swagger API 的编辑器，支持导出 yaml 和 json 格式的接口文件
> - Swagger 支持根据定义的接口导出各种语言的服务端或客户端代码
>
> 缺点：
>
> - 未集成 mock 接口调用
> - 接口管理方面不足

### sosoapi 

> swagger官方建议，但实际国内不常用
>
> - sosoapi 的文档需要在线编辑和维护，也有离线版本，管理功能薄弱
> - sosoapi 支持将文档导出为各种格式，其中就包含 Swagger 所用的 json 格式。因此可以将导出的 json 放在 Tomcat 下让 index.html 来访问。但 sosoapi 本身对json进行了扩展，所以 Swagger 的 index.html 并不能完全正确地识别。推荐使用 sosoapi 在线的API管理功能
> - sosoapi 对前端提供可直接访问的 Mock 服务。也可以通过设置接口令牌（即服务端端口），来测试后端的接口。

### rap2

> 主要面向测试
>
> 优点：
>
> - 可以直接 mock 接口调用
> - 有团队功能，方便团队接口及开发人员的管理
> - 支持 Json/XML 报文的直接导入并解析为相关 API
> - 项目为在 GitHub 已开源，可以直接 clone 到本地根据团队本身需求进行定制化修改
>
> 缺点：
>
> - 接口管理工具需要单独部署在 Tomcat 中（只支持 Tomcat），且只能部署在 Root 下（可能后续维护能修改）
> - 仍需要人员编写接口文档，并手动（或批量复制）录入接口，不能自动生成

### postman

> 主要面向测试
>
> - 管理及测试
> - 集成 mock server