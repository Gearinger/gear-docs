## maplibre + vite + vue + ts

### 1、项目初始化

```shell
# 全局安装 vite
npm i vite -g
# 确认安装依赖，输入project-name，选择vue vue-ts
npm init vite@lates
```

### 2、启动项目

```shell
# 启动项目
vite

# 查看启动选项
npx vite --help
-------------------------------------------------------------------------
  --host [host]           [string] specify hostname
  --port <port>           [number] specify port
  --https                 [boolean] use TLS + HTTP/2
  --open [path]           [boolean | string] open browser on startup
  --cors                  [boolean] enable CORS
```

### 3、创建 MapLibre 控件

> 注意vue3的组件加载顺序：
>
> 1. x先加载js外层内容
>
> 2. 渲染html的元素
>
> 3. 加载created
>
> 4. 加载mounted，重新渲染html
>
> ![实例的生命周期](https://v3.cn.vuejs.org/images/lifecycle.svg)

```html
<template lang="">
  <div id="map"></div>
</template>

<script>
  import { onMounted } from "vue";
  // 导入 maplibregl
  import maplibregl, { Map, StyleSpecification } from "maplibre-gl";
  // 导入 maplibregl 相关样式
  import "maplibre-gl/dist/maplibre-gl.css";

  onMounted(() => {
    // 初始化地图
    var map = new maplibregl.Map({
      container: "map", // container id
      style: "https://api.maptiler.com/maps/streets/style.json?key=get_your_own_OpIi9ZULNHzrESv6T2vL",
      center: [113.46, 22.88], // starting position [lng, lat]
      zoom: 9, // starting zoom
    });

    // Add zoom and rotation controls to the map.
    map.addControl(new maplibregl.NavigationControl({}));
  });
</script>\

<style>
  body {
    margin: 0;
    padding: 0;
  }

  #map {
    position: absolute;
    top: 0;
    bottom: 0;
    width: 100%;
  }
</style>
```

### 4、MapLibre GL 功能简介

#### （1）map

`map` 的图层和图层源均在 `style` 中，可通过 `map.getStyle()` 获取到 `style`

给 `map` 添加图层时，需要先挂在数据源到 `map` 上，再添加 `layer`

~~~js

~~~