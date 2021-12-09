# Typora添加gitee作为图床

## 1、Typora偏好设置

![image-20210904113659514](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/2021-09-04 11-42-21_image-20210904113659514.png)

## 2、安装picgo-core插件

~~~sh
C:\Users\用户名\AppData\Roaming\Typora\picgo\win64>picgo install gitee-uploader super-prefix
~~~

## 3、配置picgo-core的json文件

> "repo": "gearinger/gear-markdown-pictures"中，仓库名必须与浏览器中访问url一致。其他设置也别改。
>
> ![image-20210904114558516](https://gitee.com/gearinger/gear-markdown-pictures/raw/picgo/2021-09-04 11-46-00_image-20210904114558516.png)

~~~json
{
  "picBed": {
    "uploader": "gitee",
    "transformer": "path",
    "gitee": {
      "repo": "gearinger/gear-markdown-pictures",
      "token": "**************",
      "path": "",
      "customUrl": "",
      "branch": "picgo"
    }
  },
  "picgoPlugins": {
    "picgo-plugin-gitee-uploader": true,
    "picgo-plugin-super-prefix": true
  },
  "picgo-plugin-super-prefix": {
    "fileFormat": "YYYYMMDD-HHmmss"
  },
  "picgo-plugin-gitee-uploader": {
    "lastSync": "2021-10-09 04:46:55"
  }
}
~~~

