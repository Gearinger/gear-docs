## Git的简单使用

### 一、本地仓库创建

```sh
# 创建仓库
git init

# 创建裸仓库（用于远程服务器，其中没有当前版本的文件）
git init --bare
```

> 服务器端需要使用裸仓库。裸仓库在服务器上不能操作。普通仓库可在服务器端操作，容易产生冲突。
> 
> 如果使用普通仓库，客户端进行推送的时候会报错，需要在服务器端执行以下命令：
> 
> ```sh
> git config receive.denyCurrentBranch warn
> ```

```sh
# clone远程仓库（最后的文件可以是".git"也可以是"/.git"
git clone ssh://用户@ip:端口/目录

# 示例
git clone ssh://root@182.61.27.134:23333/home/git/Django.git
```

服务器端需要使用裸仓库。裸仓库在服务器上不能操作。普通仓库可在服务器端操作，容易产生冲突。

```sh
# 普通仓库
git init

# 裸仓库
git init --bare
```

如果使用普通仓库，客户端进行推送的时候会报错，需要在服务器端执行以下命令

```sh
git config receive.denyCurrentBranch warn
```

### 二、远程仓库使用

#### （1）克隆远程仓库

不存在本地仓库，需要从远程仓库获取内容

```sh
# clone远程仓库（最后的文件可以是".git"也可以是"/.git"
git clone ssh://用户@ip:端口/目录

# 示例
git clone ssh://root@182.61.27.134:23333/home/git/Django.git
```

#### （2）推送到远程仓库

存在本地仓库，远程仓库为空，需要将本地内容覆盖到远程仓库

```sh
# 添加远程仓库
git remote add origin ssh://root@182.61.27.134:23333/home/git/Django.git

# 提交本地修改
git add .
git commit -m "init message"
# 推送到远程仓库
git push -u origin master
```

### 二、基本命令

#### （1）add

#### （2）commit

#### （3）clone

#### （4）pull/fetch

#### （5）push

### 三、裸仓库

裸仓库本身是不包含当前工作目录，没有上传的源码内容。不过，包含hooks，可以通过hook进行自动部署。

#### （1）hook的使用

```sh
cd git/hooks
touch post-receive && vim post-receive

# post-receive文件中添加以下内容
#!/bin/sh
DEPLOY_PATH=/home/wwwroot/default/myproject/  #这个路径是服务器上项目的目录位置
**#**在这个目录中要记得先克隆一下git的项目,这一条很重要****
unset  GIT_DIR #这条命令很重要
cd $DEPLOY_PATH
git reset --hard
git pull
chown root:root -R $DEPLOY_PATH

# 给post-receive执行权限
chmod +x post-receive
```
