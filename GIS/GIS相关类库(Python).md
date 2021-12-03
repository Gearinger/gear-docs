# GIS相关类库(Python)

## 一、基础类库（抽象库）

- GDAL/OGR 是大部分开源GIS的基础，也包括如ArcGIS、FME这样的商业软件 打开 ；
- Proj.4 地图投影类库 打开；
- geojson类库，用于 GeoJson 格式的数据处理
- Rasterio用于栅格影像处理
- Geos是由C开发的空间关系与分析类库

## 二、Python类库

- Shapley 是基于 Geos 的封装 Python 库
- Fiona 用于矢量数据的读入、写出
- Rtree 是Rtree空间索引的类库
- pyproj 是Proj.4的Python 接口扩展
- python-rasterstats 用于栅格数据的计算
- OWSLib 基于OGC标准进行信息访问
- Basemap 基于 Matplotlib 的绘图库
- Descartes 运用matplotlib对空间数据画图
- Mercantile 球面墨卡托投影

## 三、GIS工具

- GeoPandas 整合了pandas, shapely, fiona, descartes, pyproj 和 rtrees，用于数据处理
- GeoDjango django出品，集成了GIS功能的门户网站程序
- python-rasterstats 栅格数据统计

## 四、桌面软件接口

- ArcPy
- pyQGIS