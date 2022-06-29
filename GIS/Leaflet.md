[Leaflet 官方文档](https://leafletjs.com/reference.html)

[Leaflet 插件](https://leafletjs.com/plugins.html)

## 一、简单示例

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.8.0/dist/leaflet.css"
              integrity="sha512-hoalWLoI8r4UszCkZ5kL8vayOGVae1oxXe/2A4AO6J9+580uKHDO3JdHb7NzwwzK5xr/Fs0W40kiNHxM9vyTtQ=="
              crossorigin=""/>
        <script src="https://unpkg.com/leaflet@1.8.0/dist/leaflet.js"
                integrity="sha512-BB3hKbKWOc9Ez/TAwyWxNXeoV9c1v6FIeYiBieIWkpLjauysF18NzgR1MBNBXf8/KABdlkX68nAhlwcDFLGPCQ=="
                crossorigin=""></script>
        <style>
            #map { height: 800px; }
        </style>
    </head>
    <body>
        <!-- 承载map的容器 -->
        <div id="map"></div>
    </body>
    <script>
        // initialize the map on the "map" div with a given center and zoom
        var map = L.map("map", {
            center: [51.505, -0.09],
            zoom: 13,
        });
    </script>
</html>
</body>
</html>
```

## 二、Vue + Leaflet

### （1）安装 Leaflet

```shell
npm i leaflet
```

### （2）导入并挂载 Leaflet

```js
import * as L from 'leaflet'

// 使得在vue控件中，可用L、this.$L去访问Leaflet
Vue.L = Vue.prototype.$L = L

// Leaflet 图标访问异常时，可将资源下载换到本地
delete L.Icon.Default.prototype._getIconUrl
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('./assets/images/marker-icon-2x.png'),
  iconUrl: require('./assets/images/marker-icon.png'),
  shadowUrl: require('./assets/images/marker-shadow.png'),
})
```

### （3）map 控件

```js
<template>
    <div id='map'></div>
</template>

<script>
    export default{
    name: 'map',
    data() {
        return {
        map: null,
        }
    },
    methods: {
        let map = L.map("map", {
            center: [23, 113.5], // 中心位置
            minZoom: 3,
            maxZoom: 21,
            zoom: 10, // 缩放等级
            zoomControl: false,
            attributionControl: false, // 版权控件
        });
        this.map = map; // data上需要挂载
    }
}
</script>

<style>
</style>
```

## 三、常用插件

[Plugins - Leaflet - a JavaScript library for interactive maps (leafletjs.com)](https://leafletjs.com/plugins.html)

### 1、要素编辑

[leaflet-geoman](https://github.com/geoman-io/leaflet-geoman)

图形要素创建、编辑、缩放、旋转等操作

### 2、地名地址搜索

[Leaflet GeoSearch (smeijer.github.io)](https://smeijer.github.io/leaflet-geosearch/)

具体内容待补充……

## 四、GIS 类库

### 1、Turf

[Turf.js | Advanced geospatial analysis (turfjs.org)](http://turfjs.org/)

关于[Turf怎么用](/GIS/Turf)

## 五、使用 Leaflet 的系统

