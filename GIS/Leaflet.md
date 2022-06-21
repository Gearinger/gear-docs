# LeafLet

| name | info |     |
| ---- | ---- | --- |
|      |      |     |
|      |      |     |
|      |      |     |

## example

```js

```

## 结构

```js
- map
  - options
  - remove()    // 移除地图

  - addControl(control)    // 添加控件
  - removeControl(control)    // 移除控件
  - addHandle(name, HandlerClass)    // 添加回调

  - addLayer(layer)    // 添加图层
  - hasLayer(layer)    //
  - eachLayer(method, context)
  - removeLayer(layer)

  - panTo(center, options)
  - panBy(offset, options)
  - zoomIn(delta, options)
  - zoomOut(delta, options)
  - project(latlng, zoom)

  - fitBounds(bounds, options)    // 缩放至范围
  - fitWorld(options)    // 缩放至全图
  - flyTo(targetCenter, targetZoom, options)
  - flyToBounds(bounds, options)
  - setMaxBounds(bounds)
  - getBounds()
  - getPixelBounds()

  - distance(latlng1, latlng2)
  - latLngToContainerPoint(latlng)
  - latLngToLayerPoint(latlng)
  - layerPointToContainerPoint(point)
  - layerPointToLatLng(point)

  - openPopup(popup, latlng, options)
  - closePopup(popup)
  - openTooltip(tooltip, latlng, options)
  - closeTooltip(tooltip)
  - createPane(name, container)
  - getPane(pane)
  - getPanes()

  - _layers    // 获取所有图层
```

```js
- layer // 要素和图层均为layer
```

## style

```js
layer.setStyle({
  weight: 2,
  opacity: 1,
  color: 'red',
  dashArray: '4',
  fillOpacity: 0.2,
  fillColor: '#FFEDA0'
});
```

## LeafLet.pm

### 结构

```js
- map
  - options
  - pm

  - remove()

  - addControl(control)
  - removeControl(control)
  - addHandle(name, HandlerClass)

  - addLayer(layer)
  - hasLayer(layer)
  - eachLayer(method, context)
  - removeLayer(layer)

  - panTo(center, options)
  - panBy(offset, options)
  - zoomIn(delta, options)
  - zoomOut(delta, options)
  - project(latlng, zoom)

  - fitBounds(bounds, options)    // 缩放至范围
  - fitWorld(options)    // 缩放至全图
  - flyTo(targetCenter, targetZoom, options)
  - flyToBounds(bounds, options)
  - setMaxBounds(bounds)
  - getBounds()
  - getPixelBounds()

  - distance(latlng1, latlng2)
  - latLngToContainerPoint(latlng)
  - latLngToLayerPoint(latlng)
  - layerPointToContainerPoint(point)
  - layerPointToLatLng(poing)

  - openPopup(popup, latlng, options)
  - closePopup(popup)
  - openTooltip(tooltip, latlng, options)
  - closeTooltip(tooltip)
  - createPane(name, container)
  - getPane(pane)
  - getPanes()
```
