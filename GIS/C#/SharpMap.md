# SharpMap-WPF

## 一、引用

- WindowsFormsIntegration.dll
- SharpMap（nuget中添加）
- SharpMapUI（nuget中添加）

## 二、控件使用

```xaml
<WindowsFormsHost x:Name="Map" Grid.Row="1">
    <smui:MapBox/>
</WindowsFormsHost>
```

```C#
var mapBox = Map.Child as MapBox;
mapBox.BackColor = Color.LightGray;
```
