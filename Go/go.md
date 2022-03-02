# Go语言

> （1）推荐使用 1.13 及以后版本

## 示例教程

登陆官网下载安装，添加环境变量（windows会自动添加环境变量）。

示例代码 `test.go`：

~~~ go
// 代码示例
package main

// 输出类库
import "fmt"

func main(){
    hello("Tom")
}

func hello(s string) string {
    return "hello " + s + "!"
}
~~~

执行代码：

~~~sh
// 运行文件
go run test.go

// 编译成可执行文件
go build test.go
~~~



## 环境配置

支持的平台：Linux、FreeBSD、Mac OS、Windows

1、下载

2、安装

3、配置环境变量



## 结构

1、包管理

> 之前 Go 语言的包管理很杂乱，在 1.12 版本后，官方推荐使用modules。
>
> 以下使用 modules 管理。go 1.12 版本前与以下描述不同

### （1）初始化 modules

~~~go
go mod init test
~~~

### （2）命令

```go
// 列出当前项目的所有依赖
go list -m -u all

// 将 package 包的依赖更换到 version 版本
go get package@version

// 初始化modules
go mod init
// 下载modules到本地cache
go mod download
// 编辑go.mod文件，选项有-json、-require和-exclude，可以使用帮助go help mod edit
go mod edit
// 以文本模式打印模块需求图
go mod graph
// 检查，删除错误或者不使用的modules，下载没download的package
go mod tidy
// 生成vendor目录
go mod vendor
// 验证依赖是否正确
go mod verify
// 查找依赖
go mod why
// 执行一下，自动导包
go test    
// 主模块的打印路径
go list -m
// print主模块的根目录
go list -m -f={{.Dir}}
// 查看当前的依赖和版本信息
go list -m all
```

### （3）私有仓库的包管理

添加环境变量后，go get 遇到该域名便会通过 git 去拉取对应代码。

~~~go
export GOPRIVATE=gitlab.com/xxx 
or
go env -w GOPRIVATE=gitlab.com/xxx
~~~



2、包（package）

（1）一个文件夹下所有的子文件属于同一个包



3、go文件

4、类

5、函数

6、语法

7、常用类库及函数

## 常用框架

### Gin

### Beego

## 开源项目