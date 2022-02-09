# Vue

## 环境



## 结构

![实例的生命周期](https://v3.cn.vuejs.org/images/lifecycle.svg)

## 快速入门

### 一、nodejs

#### （1）下载

[Download | Node.js (nodejs.org)](https://nodejs.org/en/download/)

#### （2）路径配置

node_global（全局依赖的安装位置） 和 node_cache（缓存位置）

~~~sh
# 原路径在 C:\Users\Administrator\AppData\Roaming
npm config set prefix "D:\Program Files\nodejs\node_global"
npm config set cache "D:\Program Files\nodejs\node_cache"
~~~

#### （3）环境变量

~~~
NODE_PATH	D:\Program Files\nodejs\node_global\node_modules
PATH		D:\Program Files\nodejs\node_global
~~~



#### （4）测试

~~~sh
# 查看版本号
npm -v
~~~

#### （5）常用命令/工具

~~~sh
# 安装
npm install			# 安装
npm install -g		# 全局安装
npm -i

# 配置镜像源
npm config set registry=http://registry.npm.taobao.org
# 查看镜像源列表
npm config list

# yarn

# 最新稳定版vue
$ npm install vue@next

# vue-cli
npm install -g @vue/cli
# OR
yarn global add @vue/cli

# 更新
npm update -g @vue/cli
# 或者
yarn global upgrade --latest @vue/cli

~~~



## 知识点

### 1、JS关键字

#### export
模块是独立的文件，该文件内部的所有的变量外部都无法获取。如果希望获取某个变量，必须通过export输出

- 单个变量/函数/类输出

~~~js
// profile.js
export var firstName = 'Michael';
export var fun1 = (a, b)=>{return a+b;};
~~~

- 多个变量/函数/类同时输出

~~~js
// profile.js
var firstName = 'Michael';
export var fun1 = (a, b)=>{return a+b;};

export {firstName, fun1 as funTest};
~~~

- export default

~~~js
// export-default.js
export default function () {
  console.log('foo');
}
~~~

~~~js
// 加载该模块时，import命令可以为该匿名函数指定任意名字
// import-default.js
import customName from './export-default';
customName(); // 'foo'
~~~



#### import

export定义了模块的对外接口后，其他JS文件就可以通过import来加载这个模块

~~~js
// main.js
import {firstName, funTest} from './profile';

function setName(element) {
  element.textContent = firstName;
  element.age = funTest(10,10);
}
~~~

- import()

放在语句中，对括号内的内容进行加载

~~~js
// import模块在事件监听函数中，只有用户点击了按钮，才会加载这个模块。
button.addEventListener('click', event => {
  import('./dialogBox.js')
  .then(dialogBox => {
    dialogBox.open();
  })
  .catch(error => {
    /* Error handling */
  })
});
~~~

### 2、this.$message

~~~js
// 通知消息
this.$message.info();
this.$message.warning();
this.$message.error();
~~~

### 3、引用 iconfont

[iconfont-阿里巴巴矢量图标库](https://www.iconfont.cn/help/detail?spm=a313x.7781069.1998910419.d8cf4382a&helptype=code)

采用 font-class 引用。

1. 在 www.iconfont.cn 上将图标添加到一个项目中
2. 进入该项目，并点击下载至本地
3. 将所有文件拷贝到本地代码项目，并引用

~~~js
<template lang="">
    <div>
  		// 页面上的icon
        <i class="iconfont" :class="iconfont icon-shouye"></i>
    </div>
</template>

<script>
// 引用 iconfont 文件
import "../assets/icon/ali icon/iconfont.css";
export default {
  name: iconTest
  data() {
  }
}
</script>

<style>
</style>
~~~

### 4、添加 leaflet 

### 5、elementui 主题

### 6、elementui 多语言

### 7、地图上显示统计信息控件

## ISSUE

#### 1、vue的index代理问题



~~~js
proxyTable: {
  '/api': {
    target: 'http://127.0.0.1:9000', // 你请求的第三方接口
      changeOrigin: true, // 在本地会创建一个虚拟服务端，然后发送请求的数据，并同时接收请求的数据，这样服务端和服务端进行数据的交互就不会有跨域问题
        pathRewrite: { // 路径重写，
          '^/api': '/api' // http://127.0.0.1:9000/api/helloworld 会被替换为 http://127.0.0.1:9000/helloworld。
        }
  }
},
~~~

#### 2、下载文件

~~~js
// 获取二进制流
const reqByBlob = (method, url, params) => {
  return axios({
    method: method,
    url: url,
    transformRequest: [
      function (data) {
        let ret = ''
        for (let it in data) {
          ret += encodeURIComponent(it) + '=' + encodeURIComponent(data[it]) + '&'
        }
        ret = ret.substring(0, ret.lastIndexOf('&'));
        return ret
      }
    ],
    headers: {
      token: localStorage.getItem('logintoken')
    },
    data: params,
    responseType: "arraybuffer",
  });
};
~~~

~~~js
export const downloadFile = (params) => { return reqByBlob("post", "/api/fieldmanagesystem/file/download", params) };
~~~

~~~js
downloadFile({ fileId: "1485852740822310913" }).then((response) => {
  var filename = response.headers; //下载后文件名
  filename = filename["content-disposition"];
  filename = decodeURI(filename.split(";")[1].split("filename=")[1]);
  var blob = new Blob([response.data]);
  var downloadElement = document.createElement("a");
  var href = window.URL.createObjectURL(blob); //创建下载的链接
  downloadElement.href = href;
  downloadElement.download = filename;
  document.body.appendChild(downloadElement);
  downloadElement.click(); //点击下载
  document.body.removeChild(downloadElement); //下载完成移除元素
  window.URL.revokeObjectURL(href); //释放掉blob对象
});
~~~

#### 3、Vue组件里的Style中如何引用data中的数据

[在Vue组件里的Style中如何引用data中的数据 - 简书 (jianshu.com)](https://www.jianshu.com/p/ddd5e15235c5)