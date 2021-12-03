# Intelij Idea中git的使用

## 一、git项目初始化

（1）安装git安装包

[Git - Downloads (git-scm.com)](https://git-scm.com/downloads)

（2）初始化

点击VCS --》 Import… --》Create Git Rep…

![image-20210811095010765](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-1748.png)

（3）添加ignore文件（git仓库中会忽略文件中匹配的文件）

安装.ignore插件

![image-20210811095649172](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-175041.png)

项目目录上右键，选择.gitignorefile(Git)

![image-20210811095445967](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-1749.png)

再在以下窗口勾选maven、java

![image-20210811095620388](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-1750.png)

## 二、提交

在commit窗口下方添加本次提交的注释，提交。该次修改便已存入本地仓库。

![image-20210811095300853](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-175056.png)

## 三、添加远程与同步（多人协作则需要）

![image-20210811095937755](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-175100.png)

网页上访问gitlab，创建远程仓库，git链接如下。把链接填入上一步的remotes弹出的窗口中。注：gitlab、github都差不多

![image-20210811100147295](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-175116.png)

推送到远程（本地要先完成提交）

![image-20210811100422008](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-175122.png)

从远程拉取（本地要先完成提交）

![image-20210811100349446](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-175135.png)

## 四、合并冲突

拉取远程仓库内容时，存在冲突会弹窗提醒，根据提醒进行编辑即可

## 五、历史查看

![image-20210811095904778](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20211203-175125.png)