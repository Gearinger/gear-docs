## KODI

开源免费。

KODI 可连接文件夹、SMB、NFS、共享文件夹等文件协议的内容。建议所有电影都单独放一个文件夹，电影文件名与电影名称一致。

KODI 使用所在客户端进行解码播放，对服务器性能影响很小。

KODI 海报墙的生成需要使用搜刮器。默认用的是TMDB（https://www.themoviedb.org/）

### 教程

官网：[Open Source Home Theater Software | Kodi](https://kodi.tv/)

#### （1）安装

下载客户端对应版本的 KODI，进行安装。[Download | Kodi](https://kodi.tv/download)

#### （2）配置数据源

点击“电影”

![image-20220109191256870](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-191258.png)

添加视频

![image-20220109191312001](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-191313.png)

点击浏览

![image-20220109191340448](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-191341.png)

选择磁盘或对应协议的资源

![image-20220109191412898](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-191414.png)

弹窗“设置内容”中填写如下

![image-20220109192013083](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-192014.png)

#### （3）生成海报墙

若（2）步骤未产生海报墙，则可使用 [tinyMediaManager](https://www.tinymediamanager.org/) 进行海报信息的抓取。将视频源对应文件夹加入到`tinyMediaManager`

![image-20220109192343596](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-193500.png)

点击“更新所有数据源”，后台会自动下载电影封面、信息到对应文件夹。

![image-20220109192428556](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/20220109-193458.png)