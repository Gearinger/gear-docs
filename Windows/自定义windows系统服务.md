## 一、命令行安装服务

```sh
# 注意事项：
#     exe假如需要读写配置文件，那么配置文件必需写绝对路径，
#     因为以服务启动时的工作路径是System32，不写绝对路径会导致读写配置文件失败

#    另外需要将SERVICE用户添加到当前用户所在组(Administrators)，否则需要权限的操作将失败。
# ----1----
sc create MyService binpath= "C:\FTP\server\s.exe" start= auto displayname= "MyService"
sc description MyService "MyService..."
# ----2----
# 将SERVICE用户添加到当前用户所在组(Administrators)
# ----3----
# 启动服务进行测试
```

## 二、instsrv 安装开机自启服务

```sh
# ----------------
# instsrv 安装开机自启服务
# ----1-----
# 32位系统
# 将instsrv.exe和srvany.exe拷贝到C:\WINDOWS\system32目录下
# 64位系统
# 将instsrv.exe和srvany.exe拷贝到C:\WINDOWS\SysWOW64目录下
# ----2----
# 服务注册表路径:
# HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\MyService
# 安装服务:
instsrv MyService C:\WINDOWS\system32\srvany.exe
# ----3----
# 打开注册表：（cmd中输入：regedit）
# ctrl+F，搜索Myservice（之前自定义的服务名称）
# 右击Myservice新建项，名称为 Parameters
# 之后在 Parameters 项中新建以下几个字符串值
# 名称 Application 值：作为服务运行的程序的绝对路径("C:\FTP\server\s.exe")
# 名称 AppDirectory 值：作为服务运行的程序所在文件夹路径("C:\FTP\server\")
# 名称 AppParameters 值：作为服务运行的程序启动所需要的参数，无参数留空
# ----4----
# 将SERVICE用户添加到当前用户所在组(Administrators)
# ----5----
# 启动服务进行测试
```
