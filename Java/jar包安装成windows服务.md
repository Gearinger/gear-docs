# 利用`WinSw`将`jar`包安装为`windows`服务

[Releases · winsw/winsw (github.com)](https://github.com/winsw/winsw/releases)

## 1、下载 `sample-minimal.xml`、`WinSW-x64.exe`、`WinSW.NET4.exe`

## 2、修改 `sample-minimal.xml`，重命名为`WinSW-x64.xml`

~~~xml
<service>
  <!-- 唯一id -->
  <id>test</id>
  <!-- 服务名称 -->
  <name>test</name>
  <!-- 服务描述 -->
  <description>This is test service.</description>
  <!-- java环境变量 -->
  <env name="JAVA_HOME" value="%JAVA_HOME%"/>
  <executable>java</executable>
  <arguments>-jar "D:\data\Gitee\gear-springboot-win-service\target\gear-springboot-win-service-1.0-SNAPSHOT.jar"</arguments>
  <!-- 开机启动 -->
  <startmode>Automatic</startmode>
  <!-- 日志配置 -->
  <logpath>%BASE%\log</logpath>
  <logmode>rotate</logmode>
</service>
~~~

## 3、执行安装命令

~~~sh
# 安装服务
WinSW-x64.exe install

# 启动服务
WinSW-x64.exe start

# 停止服务
WinSW-x64.exe stop

# 卸载服务
WinSW-x64.exe uninstall
~~~

命令如下表：

| Command                                  | Description                              |
| ---------------------------------------- | ---------------------------------------- |
| [install](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#install-command) | Installs the service.                    |
| [uninstall](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#uninstall-command) | Uninstalls the service.                  |
| [start](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#start-command) | Starts the service.                      |
| [stop](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#stop-command) | Stops the service.                       |
| [restart](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#restart-command) | Stops and then starts the service.       |
| [status](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#status-command) | Checks the status of the service.        |
| [refresh](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#refresh-command) | Refreshes the service properties without reinstallation. |
| [customize](https://github.com/winsw/winsw/blob/v3/docs/cli-commands.md#customize-command) | Customizes the wrapper executable.       |
| dev                                      | Experimental commands.                   |