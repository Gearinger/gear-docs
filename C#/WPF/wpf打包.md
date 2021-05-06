# WPF打包流程（--CloudH）

VS2019打包WPF安装程序最新教程，使用Visual Studio 2019开发的WPF程序如果想要打包为安装程序，除了在VS2019找到WPF项目类库直接右键发布之外，更常用的还是将其打包为exe或者msi的安装程序；打包成安装程序的话，客户得到安装程序直接安装即可使用，即使在离线环境情况下，安装好就可以使用了。

一些传统行业发布程序时，比较常用这种方法，如医疗，教育等。

## 演示程序打包一览

在本教程中，我完整的打包了一个简单的WPF程序，最终安装好了以后，在桌面有一个我的程序的快捷方式图标，点击这个图标即可打开应用程序。

[![WPF安装程序桌面图标](https://img.hotbests.com/2019/11/jhrs-logo.png)](https://img.hotbests.com/2019/11/jhrs-logo.png)WPF安装程序桌面图标

 

程序运行后的效果如下所示：

[![VS2019打包WPF安装程序运行效果](https://img.hotbests.com/2019/11/run-images.png)](https://img.hotbests.com/2019/11/run-images.png)VS2019打包WPF安装程序运行效果 

## VS2019打包WPF安装程序步骤

使用VS2019打包WPF安装程序有很多种方法，本篇教程基于VS扩展插件Microsoft Visual Studio Installer Projects工具来打包，实际上此工具，在VS2010时自带有，只是后面版本的Visual Studio取消了此插件，现在需要单独安装。

### 安装打包Installer插件

安装Microsoft Visual Studio Installer Projects插件有两种方式。一是下载插件单独安装，二是在VS里面在线安装。

Microsoft Visual Studio Installer Projects下载地址：

官方下载地址：[点击下载](https://marketplace.visualstudio.com/items?itemName=visualstudioclient.MicrosoftVisualStudio2017InstallerProjects)

 

下载下来后，你会在你的保存目录看到此文件的图标是这样的，直接双击安装就可以了，如果打开了Visual Studio，先将VS关闭后再安装即可。

[![安装插件](https://img.hotbests.com/2019/11/installProjectsvsix.png)](https://img.hotbests.com/2019/11/installProjectsvsix.png)

安装插件

如果你不能从官网下载到，可以从本站直接下载即可。离线下载安装的方式适用于断网环境开发。

VS在线安装Microsoft Visual Studio Installer Projects

Microsoft Visual Studio Installer Projects插件也可以在线直接安装，步骤为：点击菜单栏【扩展（X）】，然后在弹出来的一个窗体里面，在右侧搜索框里面搜索“Microsoft Visual Studio Installer Projects”，一般第1个就是它了，然后点击Download（下载），然后安装就可以了。

[![VS在线安装Microsoft Visual Studio Installer Projects](https://img.hotbests.com/2019/11/install-online.png)](https://img.hotbests.com/2019/11/install-online.png)VS在线安装Microsoft Visual Studio Installer Projects

点击Download后如下：

[![下载插件](https://img.hotbests.com/2019/11/down-installprojectsvsix.png)](https://img.hotbests.com/2019/11/down-installprojectsvsix.png)下载插件

下载完毕后，你需要把VS关闭掉，它会自动的安装。

[![自动安装插件](https://img.hotbests.com/2019/11/auto-install.png)](https://img.hotbests.com/2019/11/auto-install.png)自动安装插件

安装好了后，启动VS即可。

### 创建安装项目

重新打开Visual Studio，打开一个你现有的包含WPF项目的解决方案即可，然后创建安装项目。在解决方案上右键 –> 【新建项目】–> 【Setup Project】，添加Setup Project项目时，VS2019可以搜索项目模板，如下图所示。

[![创建安装项目](https://img.hotbests.com/2019/11/create-project.png)](https://img.hotbests.com/2019/11/create-project.png)创建安装项目

创建好了后，主界面变成如下图所示：

[![安装项目主界面](https://img.hotbests.com/2019/11/install-project-mainform.png)](https://img.hotbests.com/2019/11/install-project-mainform.png)安装项目主界面

左边窗口三个文件夹图片说明如下：

Application Folder：应用程序包含的文件设置，指最终在客户电脑上的安装根目录。如下图所示：

[![应用程序目录子目录](https://img.hotbests.com/2019/11/in.png)](https://img.hotbests.com/2019/11/in.png)应用程序目录子目录

User’s Desktop：用户桌面快捷方式设置，用户桌面，一般放个快捷图标。

User’s Programs Menu：用户启动菜单的快捷方式设置，一般也是放快捷图标。

Application Folder是安装程序的根目录，你编写的程序生成的dll，安装后就存放在这个目录。

### 添加项目输出

安装项目建好了后，需要要往里面添加项目输出，操作方式为：右键Application Folder —>Add—>项目输出。

该操作也可以直接在安装程序项目类库上面通过右键操作来添加项目输出，如下图所示：

[![右键设置属性](https://img.hotbests.com/2019/11/project-property.png)](https://img.hotbests.com/2019/11/project-property.png)右键设置属性

### 设置项目属性

项目属性的设置，是用于最终一个生成安装程序的描述信息，这个描述信息，这个描述信息主要内容有程序的作者，标题，公司信息，技术支持等等。最直观的方式可以通过2种方式查看。

第一种查看方式：安装前将鼠标放到安装程序文件上，会有提示信息，如下图所示：

[![属性提示](https://img.hotbests.com/2019/11/set-project-property.png)](https://img.hotbests.com/2019/11/set-project-property.png)属性提示

第二种查看方式：安装后在控制面板处，找到安装程序，即可查看，如下图所示：

[![控制面板看到的安装后程序描述](https://img.hotbests.com/2019/11/property-description.png)](https://img.hotbests.com/2019/11/property-description.png)控制面板看到的安装后程序描述

 

项目属性的设置方式为：（1）左键选中项目，（2）点击解决方案栏属性，注意，不是右键选择属性，而是如下图一样选择属性。

[![设置安装程序属性](https://img.hotbests.com/2019/11/set-steps.png)](https://img.hotbests.com/2019/11/set-steps.png)设置安装程序属性

当你点了属性后，会出现如下的窗口。

[![设置属性主窗口](https://img.hotbests.com/2019/11/property-main-form.png)](https://img.hotbests.com/2019/11/property-main-form.png)设置属性主窗口

在当前的演示程序中，我是按照上图做的设置，设置都很简单，不需要做额外的解释，如果有不明白的，可以加群与我联系。

### 添加快捷方式图标

程序安装好，我们当然希望用户能够快速的打开我们的应用程序，你就需要为你的安装程序制作快捷方式，方法很简单。

方法：（1）中间窗口右键，创建新的快捷方式

[![创建新的快捷方式](https://img.hotbests.com/2019/11/set-short.png)](https://img.hotbests.com/2019/11/set-short.png)创建新的快捷方式

（2）弹窗里面选择Application Folder，双击进入另外一个界面

[![ 创建新的快捷方式第2步](https://img.hotbests.com/2019/11/set-short-2.png)](https://img.hotbests.com/2019/11/set-short-2.png)创建新的快捷方式第2步

双击后，进入下图这个界面，选择主输出即可。

[![创建新的快捷方式第3步](https://img.hotbests.com/2019/11/set-short-3.png)](https://img.hotbests.com/2019/11/set-short-3.png)创建新的快捷方式第3步

完了后点击OK按钮，就进入下图这个界面。然后将快捷方式名称改为你应用程序的名称。

[![改快捷方式图标名称](https://img.hotbests.com/2019/11/change-short-name.png)](https://img.hotbests.com/2019/11/change-short-name.png)改快捷方式图标名称

改名后的效果：

[![改名后的效果](https://img.hotbests.com/2019/11/change-short-success.png)](https://img.hotbests.com/2019/11/change-short-success.png)改名后的效果

最后一步，也是最重要一步，在上图中选中改名后的图标，将其拖到左侧窗口User’s Desktop目录即可。

[![拖动快捷方式图标到对应位置](https://img.hotbests.com/2019/11/droag.gif)](https://img.hotbests.com/2019/11/droag.gif)拖动快捷方式图标到对应位置

开始菜单图标（User’s Programs Menu）设置方式同上面的步骤是一样的，这里就不再重复了。

### 依赖文件

打包正式项目的时候，界面程序可能依赖于很多其它类库，或者第3方的dll文件，我们需要把它们一起打包，并且这些第3方程序或者dll需要同主程序在同一个安装路径下，那么在打包时，也就需要额外的把这些文件也打包进来。

所有的操作都可以在中间窗口通过右键添加文件，程序集来实现，如下图所示

[![添加依赖文件](https://img.hotbests.com/2019/11/yl.png)](https://img.hotbests.com/2019/11/yl.png)添加依赖文件

### 添加注册表项目

制作的安装包如果要添加注册表项目，可以通过选中安装程序项目，然后右键，在弹出的菜单里面找到【View】，即可以添加注册表项目，按照提示一步一步操作即可。

另外有些打包的程序，需要在安装前或者安装后做一些额外的操作，都可以通过自定义操作来实现，如主程序安装好了以后，还得安装一个windows服务程序，再安装另外一个自动升级程序，都可以通过这里来实现。

[![添加注册表项目](https://img.hotbests.com/2019/11/register.png)](https://img.hotbests.com/2019/11/register.png)添加注册表项目

以上的基本操作熟悉后，相信对于简单的桌面程序打包应该没有什么问题了。

另外需要注意的是，对外打包，需要更改为Release模式

## 打包依赖框架

最后再说一下关于 .net 环境的问题，如果你需要在打包时，将相应版本的.Net Framework一起打包到安装程序里面也是可以的，只是要注意，有可能你的打包机器上并没有安装相应的.net framework文件，则需要到官方或者网上下载对应版本的文件，例如这个演示程序，我设定的依赖框架是 4.5.2版本的，那么需要将NDP452-KB2901907-x86-x64-AllOS-CHS.exe（.net framework 4.5.2安装文件）放到指定目录才能正常的生成打包文件。

需要将.net 的离线安装文件放到以下目录，其它版本则注意下路径即可，一般C:\Program Files (x86)\Microsoft SDKs\ClickOnce Bootstrapper\Packages

目录下面有不同版本的以DotNetFX开头的目录，如下图所示：

[![依赖框架保存目录](https://img.hotbests.com/2019/11/ylkj.png)](https://img.hotbests.com/2019/11/ylkj.png)依赖框架保存目录

[![依赖框架保存目录](https://img.hotbests.com/2019/11/save-ylkj.png)](https://img.hotbests.com/2019/11/save-ylkj.png)依赖框架保存目录

将相应的版本的.net framework框架文件放到对应的目录即可，我这个演示程序是放到下面这个目录的。

```
C:\Program Files (x86)\Microsoft SDKs\ClickOnce Bootstrapper\Packages\DotNetFX452\zh-Hans
```

具体打包步骤为：右键安装项目，选择属性，弹出窗口点击Prerequisites…按钮。再在弹出的窗口选择你应用程序需要的框架版本即可。可以选择多个。

[![Prerequisites](https://img.hotbests.com/2019/11/right-property.png)](https://img.hotbests.com/2019/11/right-property.png)Prerequisites

选择需要打包的框架版本即可。

[![框架版本](https://img.hotbests.com/2019/11/framework-version.png)](https://img.hotbests.com/2019/11/framework-version.png)框架版本

待安装程序打包成功后，即可在生成目录看到该框架的安装包，如下图所示：

[![生成目录框架文件](https://img.hotbests.com/2019/11/build-framework.png)](https://img.hotbests.com/2019/11/build-framework.png)生成目录框架文件

好了，以上就是使用VS2019打包WPF安装程序的完整步骤。

演示程序可以点击这里下载。

## 打包后安装一览

成生打包文件成功后，就可以双击msi或者exe文件进行安装了，安装效果图如下：

[![安装打包程序](https://img.hotbests.com/2019/11/install-1.png)](https://img.hotbests.com/2019/11/install-1.png)安装打包程序

选择安装目录

[![安装打包程序](https://img.hotbests.com/2019/11/install-2.png)](https://img.hotbests.com/2019/11/install-2.png)安装打包程序

在演示的这个打包程序里面，比较简单，实际上你可以添加用户协议文件，输入用户信息后才能安装，这些都可以在打包时设置。