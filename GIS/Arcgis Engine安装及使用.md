# Arcgis Engine安装及使用

## 一、安装及引用

- **Arcgis Desktop 安装**
- **License 安装**
  安装完后，停止许可服务，替换Arcgis.exe、License.txt文件，读取许可，进行破解
- **Arcgis Engine安装**
- **Arcgis Object For Framework 安装**
- **调用Arcgis组件**
  + 方式一：引用-程序集-ESRI.ArcGIS.*
  + 方式二：拖放工具箱控件



## 二、示例

### 1、设置地图按图形区域显示

~~~C#
/// <summary>
/// 设置地图按图形区域显示
/// </summary>
/// <param name="mapControl"></param>
/// <param name="geometry"></param>
public void ShowMapByShape(MapControlClass mapControl, IGeometry geometry)
{
    IMapClipOptions mapClipOptions = mapControl.ActiveView.FocusMap as IMapClipOptions;
    mapClipOptions.ClipData = geometry;
    mapClipOptions.ClipType = esriMapClipType.esriMapClipMapExtent;
    mapControl.Map.ClipGeometry = geometry;
}

~~~

### 2、绘制图形

~~~C#
/// <summary>
/// 方法一：绘制图形（使用MapControl自带方法）
/// </summary>
/// <param name="mapControl"></param>
/// <returns></returns>
public IGeometry TrackShape1(AxMapControl mapControl)
{
    return mapControl.TrackPolygon();
}

/// <summary>
/// 方法二：绘制图形（利用ScreenDisplay）
/// </summary>
/// <param name="mapControl"></param>
/// <returns></returns>
public IGeometry TrackShape2(AxMapControl mapControl)
{
    IScreenDisplay screenDisplay = mapControl.ActiveView.ScreenDisplay;
    ISimpleFillSymbol pFillSymbol = new SimpleFillSymbolClass();

    IRubberBand rubberBand = new RubberPolygonClass();
    IGeometry geometry = rubberBand.TrackNew(screenDisplay, (ISymbol)pFillSymbol);

    return geometry;
}
~~~

### 3、临时显示图形

~~~C#
/// <summary>
/// 显示图形
/// </summary>
/// <param name="mapControl"></param>
/// <param name="geometry"></param>
public void ShowShape1(AxMapControl mapControl, IPolygon polygon)
{
    // 配置样式（不同的geometry类型对应不同的symbol）
    ISimpleFillSymbol symbol = new SimpleFillSymbolClass();
    IRgbColor pColor = new RgbColor();
    pColor.Red = 11;
    pColor.Green = 120;
    pColor.Blue = 233;
    symbol.Color = pColor;
    symbol.Style = esriSimpleFillStyle.esriSFSHollow;
    symbol.Outline.Width = 2;
    object symbolObject = symbol as object;

    // 方法一
    mapControl.DrawShape(polygon, ref symbolObject);

    // 方法二
    IScreenDisplay screenDisplay = mapControl.ActiveView.ScreenDisplay;
    screenDisplay.StartDrawing(screenDisplay.hDC, 1);
    screenDisplay.SetSymbol(symbol as ISymbol);
    screenDisplay.DrawPolyline(polygon);
    screenDisplay.FinishDrawing();

    // 方法三
    IFillShapeElement pPolygonEle = new PolygonElementClass();
    pPolygonEle.Symbol = symbol;
    IElement pEle = pPolygonEle as IElement;
    pEle.Geometry = polygon;
    IGraphicsContainer pGraphicsContainer = mapControl.ActiveView.GraphicsContainer;
    pGraphicsContainer.AddElement(pEle, 0);
    mapControl.ActiveView.PartialRefresh(esriViewDrawPhase.esriViewGraphics, null, null);
}
~~~

### 4、添加比例尺

~~~C#
/// <summary>
/// 图面上添加修饰元素--比例尺
/// </summary>
/// <param name="mapControl"></param>
/// <returns></returns>
public void AddElement(AxPageLayoutControl layoutControl, IEnvelope envelope)
{
    var activeView = layoutControl.ActiveView;
    IGraphicsContainer pGraphicsContainer = activeView.GraphicsContainer;

    // 获得MapFrame  
    IFrameElement frameElement = pGraphicsContainer.FindFrame(activeView.FocusMap);
    IMapFrame mapFrame = frameElement as IMapFrame;
    //根据MapSurround的uid，创建相应的MapSurroundFrame和MapSurround  
    UID uid = new UIDClass();
    uid.Value = "esriCarto.AlternatingScaleBar";
    IMapSurroundFrame mapSurroundFrame = mapFrame.CreateSurroundFrame(uid, null);
    //设置MapSurroundFrame中比例尺的样式  
    IMapSurround mapSurround = mapSurroundFrame.MapSurround;
    IScaleBar markerScaleBar = ((IScaleBar)mapSurround);
    // IScaleBar markerScaleBar = new AlternatingScaleBarClass();
    markerScaleBar.LabelPosition = esriVertPosEnum.esriBottom;
    markerScaleBar.UseMapSettings();
    markerScaleBar.Division = 4;
    markerScaleBar.Divisions = 4;
    markerScaleBar.Map = layoutControl.ActiveView.FocusMap;
    markerScaleBar.Subdivisions = 2;
    markerScaleBar.UnitLabel = "";
    markerScaleBar.UnitLabelGap = 4;
    markerScaleBar.UnitLabelPosition = esriScaleBarPos.esriScaleBarAboveRight;
    markerScaleBar.Units = esriUnits.esriKilometers;
    mapSurround = markerScaleBar;
    //QI，确定mapSurroundFrame的位置  
    IElement element = mapSurroundFrame as IElement;
    element.Geometry = envelope;
    //使用IGraphicsContainer接口添加显示  
    pGraphicsContainer.AddElement(element, 0);
    activeView.Refresh();
    activeView.PartialRefresh(esriViewDrawPhase.esriViewGraphics, null, null);
}
~~~

### 5、CAD dwg文件

#### （1）栅格方式加载（完整显示符号，但不能选择要素）

~~~C#
IWorkspaceFactory pWorkspaceFactory = new CadWorkspaceFactoryClass();
IFeatureWorkspace pFeatureWorkspace = (IFeatureWorkspace) pWorkspaceFactory.OpenFromFile("C:\\path\\to\\CAD", 0);
ICadDrawingWorkspace pCadDrawingWorkspace = pFeatureWorkspace as ICadDrawingWorkspace;
ICadDrawingDataset pCadDataset = pCadDrawingWorkspace.OpenCadDrawingDataset("***.dwg");
ICadLayer pCadLayer = new CadLayerClass();
pCadLayer.CadDrawingDataset = pCadDataset;
pMap.AddLayer(pCadLayer);
~~~

#### （2）要素图层方式加载（可选择要素，但符号显示存在问题）

~~~C#
IWorkspaceFactory pWorkspaceFactory = new CadWorkspaceFactoryClass();
IFeatureWorkspace pFeatureWorkspace = (IFeatureWorkspace) pWorkspaceFactory.OpenFromFile("C:\\path\\to\\CAD", 0);

//CAD加载方式一：分图层加载CAD文件（包括：点、线、面和注记）                  
//打开一个要素集
IFeatureDataset pFeatureDataset = pFeatureWorkspace.OpenFeatureDataset("***.dwg");
IFeatureClassContainer pFeatureClassContainer = (IFeatureClassContainer) pFeatureDataset;
IGroupLayer pGroupLayer = new GroupLayerClass();
pGroupLayer.Name = pFeatureDataset.Name;
//遍历CAD文件中的每个要素
for (int i = 0; i < pFeatureClassContainer.ClassCount; i++) {
    IFeatureClass pFeatureClass = pFeatureClassContainer.get_Class(i);
    //加载注记图层【esriFTCoverageAnnotation】
    if (pFeatureClass.FeatureType == esriFeatureType.esriFTCoverageAnnotation) {
        IFeatureLayer pFeatureLayer = new CadAnnotationLayerClass();
        pFeatureLayer.Name = pFeatureClass.AliasName;
        pFeatureLayer.FeatureClass = pFeatureClass;
        pFeatureLayer.DataSourceType = "CAD Annotation Feature Class";//设置后Annotation的默认符号化方式是注记而不是点
        pGroupLayer.Add(pFeatureLayer);
    }
    //加载点线面图层
    else {
        IFeatureLayer pFeatureLayer = new FeatureLayerClass();
        pFeatureLayer.Name = pFeatureClass.AliasName;
        pFeatureLayer.FeatureClass = pFeatureClass;
        pGroupLayer.Add(pFeatureLayer);
    }

}
pMap.AddLayer(pGroupLayer);
~~~

### 6、遍历图层，执行方法

~~~C#
/// <summary>
/// 遍历非图层组的图层，执行方法action
/// </summary>
/// <param name="map"></param>
/// <param name="action"></param>
public static void TraverseAllLayers(IMap map, Action<ILayer> action)
{
    int layerCount = map.LayerCount;

    for (int i = 0; i < layerCount; i++)
    {
        ILayer layer = map.Layer[i];
        if (layer is IGroupLayer)
        {
            TraverseAllLayers(layer as IGroupLayer, action);
        }
        else
        {
            action(layer);
        }
    }

}

/// <summary>
/// 遍历非图层组的图层，执行方法action
/// </summary>
/// <param name="groupLayer"></param>
/// <param name="action"></param>
public static void TraverseAllLayers(IGroupLayer groupLayer, Action<ILayer> action)
{
    ICompositeLayer compositeLayer = (groupLayer as ICompositeLayer);
    int count = compositeLayer.Count;
    for (int i = 0; i < count; i++)
    {
        ILayer layer = compositeLayer.Layer[i];
        if (layer is IGroupLayer)
        {
            TraverseAllLayers(layer as IGroupLayer, action);
        }
        else
        {
            action(layer);
        }
    }
}
~~~

### 7、加载mapsserver地图

~~~C#
/// <summary>
/// 加载ArcGIS地图服务
/// </summary>
/// <param name="mapServerUrl"></param>
/// <param name="name"></param>
/// <returns></returns>
private ILayer LoadMapServer(string mapServerUrl,string name)
{
    IMapServerRESTLayer mapServerRESTLayer = new MapServerRESTLayerClass();
    mapServerRESTLayer.Connect(mapServerUrl);
    ILayer layer = mapServerRESTLayer as ILayer;
    layer.Name = name;
    return layer;
}

/// <summary>
/// 加载ImageServer地图服务
/// </summary>
/// <param name="mapServerUrl"></param>
/// <param name="name"></param>
/// <returns></returns>
private ILayer LoadMapServer(string imageServerUrl,string name)
{
    IImageServerLayer imageserverlayer = new ImageServerLayerClass();
    imageserverlayer.Initialize(imageServerUrl);
    ILayer layer = imageserverlayer as ILayer;
    layer.Name = name;
    return layer;
}
~~~

### 8、导出带坐标值的地图

~~~C#
[DllImport("GDI32.dll")]
public static extern int GetDeviceCaps(int hdc, int nIndex);
[DllImport("User32.dll")]
public static extern int GetDC(int hWnd);
[DllImport("User32.dll")]
public static extern int ReleaseDC(int hWnd, int hDC);
private static bool ExportTIFF(string sFileName)
{
    try
    {
        var mapControl1 = AppHost.Current.PluginProvider.Gets<MapControlPage>().FirstOrDefault(p => ((ControlItem)p.Tag).Id == "Map1")?.mapControl;

        ExportTIFFClass pExporter = new ExportTIFFClass();
        // 设置地图范围 (导坐标值必须设置)
        pExporter.MapExtent = mapControl1.Extent;
        // 是否导出坐标值
        pExporter.OutputWorldFile = true;

        IEnvelope pixelBoundsEnv = new EnvelopeClass();

        tagRECT displayBounds = mapControl1.ActiveView.ScreenDisplay.DisplayTransformation.get_DeviceFrame();
        tagRECT exportRECT;
        var iOutputResolution = mapControl1.ActiveView.ScreenDisplay.DisplayTransformation.Resolution;
        pExporter.Resolution = iOutputResolution;
        pExporter.ExportFileName = sFileName;
        var tmpDC = GetDC(0);
        long iScreenResolution = GetDeviceCaps((int)tmpDC, 88);
        double tempratio = iOutputResolution / iScreenResolution;
        double tempbottom = displayBounds.bottom * tempratio;
        double tempright = displayBounds.right * tempratio;
        exportRECT.bottom = (int)Math.Truncate(tempbottom);
        exportRECT.left = 0;
        exportRECT.top = 0;
        exportRECT.right = (int)Math.Truncate(tempright);

        pixelBoundsEnv.PutCoords(exportRECT.left, exportRECT.top, exportRECT.right, exportRECT.bottom);
        IEnvelope docMapExtEnv = null;
        pExporter.PixelBounds = pixelBoundsEnv;

        int hDC = pExporter.StartExporting();

        mapControl1.ActiveView.Output(hDC, Convert.ToInt32(pExporter.Resolution), ref displayBounds, docMapExtEnv, null);

        pExporter.FinishExporting();
        pExporter.Cleanup(); //清除临时文件
        //释放资源
        System.Runtime.InteropServices.Marshal.ReleaseComObject(pExporter);
        WaitHelper.CloseWaiting();
        return true;
    }
    catch (Exception e)
    {
        LogHelper.Error(e.Message);
        return false;
    }
}
~~~

