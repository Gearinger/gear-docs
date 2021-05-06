## Arcpy常用模块

- [数据访问模块](https://pro.arcgis.com/zh-cn/pro-app/arcpy/data-access/what-is-the-data-access-module-.htm) (arcpy.da)
- [制图模块](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/introduction-to-arcpy-mp.htm) (arcpy.mp)
- 元数据模块 (arcpy.metadata)
- [共享模块](https://pro.arcgis.com/zh-cn/pro-app/arcpy/sharing/introduction-to-arcpy-sharing.htm) (arcpy.sharing)
- [Image Analyst模块](https://pro.arcgis.com/zh-cn/pro-app/arcpy/image-analyst/what-is-the-image-analyst-module.htm) (arcpy.ia)
- [Spatial Analyst 模块](https://pro.arcgis.com/zh-cn/pro-app/arcpy/spatial-analyst/what-is-the-spatial-analyst-module.htm) (arcpy.sa)
- [Network Analyst 模块](https://pro.arcgis.com/zh-cn/pro-app/arcpy/network-analyst/what-is-the-network-analyst-module.htm)（arcpy.nax 和 arcpy.na）
- [Workflow Manager 模块](https://pro.arcgis.com/zh-cn/pro-app/arcpy/workflow-manager/what-is-workflow-manager-module.htm) (arcpy.wmx)



### 获取数据属性（Describe）

~~~python
desc = arcpy.Describe(object)	# 获取object的描述属性
~~~



### 字段管理

~~~python
# 获取字段
fields = arcpy.ListFields(fc, 'Flag')
fields = arcpy.ListFields(fc, 'Flag')

# 计算字段
arcpy.CalculateField_management(fc, 'Flag', '1')
~~~



### 空间参考

~~~python
# 获取目标的空间参考
desc = arcpy.Describe(object)
print(desc.spatialReference)

# 创建空间参考
sr = arcpy.SpatialReference(factoryCode)
~~~



### 环境

~~~python
# 是否覆盖输出
arcpy.env.overwriteOutput = True
~~~



### 判断是否存在

~~~python
arcpy.Exists(fc)

# 如果数据位于企业地理数据库中，则必须对名称进行完全限定。
~~~



### SQL 表达式

~~~python
whereclause = """"roadclass" = 2"""

whereclause = """{} = 2""".format(arcpy.AddFieldDelimiters(fc, fieldname))
~~~



### 游标访问数据

#### arcpy.da 查询、插入、更新

~~~python
arcpy.da.SearchCursor()
arcpy.da.InsertCursor()
arcpy.da.UpdateCursor()
~~~

多次遍历数据，则调用游标的 reset 方法

#### 查询

~~~python
import arcpy
cursor = arcpy.da.SearchCursor(fc, ['fieldA', 'fieldB'])
for row in cursor:
    print(row)
~~~

#### 插入

~~~python
import arcpy
# Create insert cursor for table
cursor = arcpy.da.InsertCursor("c:/base/data.gdb/roads_lut", 
                               ["roadID", "distance"])
# Create 25 new rows. Set the initial row ID and distance values
for i in range(0,25):
    cursor.insertRow([i, 100])
~~~

#### 更新、删除

~~~python
import arcpy
# 更新
with arcpy.da.UpdateCursor("c:/base/data.gdb/roads",
                           ["roadtype", "distance"]) as cursor:
    for row in cursor:
        # Update the values in the distance field by multiplying 
        #   the roadtype by 100. Road type is either 1, 2, 3 or 4.
        row[1] = row[0] * 100
        cursor.updateRow(row)
        

# 删除
with arcpy.da.UpdateCursor("c:/base/data.gdb/roads", 
                          ["roadtype"]) as cursor:
    # Delete all rows that have a roads type of 4
    for row in cursor:
        if row[0] == 4:
            cursor.deleteRow()
~~~



### 几何（Geometry）

#### 读取几何

| 令牌               | 说明                                                         |
| ------------------ | ------------------------------------------------------------ |
| SHAPE@             | 要素的[几何](https://pro.arcgis.com/zh-cn/pro-app/arcpy/classes/geometry.htm)对象。 |
| SHAPE@XY           | 一组要素的质心 x,y 坐标。                                    |
| SHAPE@TRUECENTROID | 一组要素的质心 x,y 坐标。这会返回与 SHAPE@XY 相同的值。      |
| SHAPE@X            | 要素的双精度 x 坐标。                                        |
| SHAPE@Y            | 要素的双精度 y 坐标。                                        |
| SHAPE@Z            | 要素的双精度 z 坐标。                                        |
| SHAPE@M            | 要素的双精度 m 值。                                          |
| SHAPE@JSON         | 表示几何的 Esri JSON 字符串。                                |
| SHAPE@WKB          | OGC 几何的熟知二进制 (WKB) 制图表达。该存储类型将几何值表示为不间断的字节流形式。 |
| SHAPE@WKT          | OGC 几何的熟知文本 (WKT) 制图表达。其将几何值表示为文本字符串。 |
| SHAPE@AREA         | 要素的双精度面积。                                           |
| SHAPE@LENGTH       | 要素的双精度长度。                                           |



#### 写入几何

~~~python
# Create a new line feature class using a text file of coordinates.
#   Each coordinate entry is semicolon delimited in the format of ID;X;Y
import arcpy
import os
# List of coordinates (ID, X, Y)
coords_list = [[1, -61845879.0968, 45047635.4861], 
               [1, -3976119.96791, 46073695.0451],
               [1, 1154177.8272, -25134838.3511],
               [1, -62051091.0086, -26160897.9101],
               [2, 17365918.8598, 44431999.7507],
               [2, 39939229.1582, 45252847.3979],
               [2, 41170500.6291, 27194199.1591],
               [2, 17981554.5952, 27809834.8945],
               [3, 15519011.6535, 11598093.8619],
               [3, 52046731.9547, 13034577.2446],
               [3, 52867579.6019, -16105514.2317],
               [3, 17160706.948, -16515938.0553]]
# The output feature class to be created
outFC = arcpy.GetParameterAsText(0)
# Get the template feature class
template = arcpy.GetParameterAsText(1)
cur = None
try:
    # Create the output feature class
    arcpy.CreateFeatureclass_management(os.path.dirname(outFC),
                                        os.path.basename(outFC), 
                                        "POLYLINE", template)
    # Access spatial reference of template to define spatial
    # reference of geometries
    spatial_reference = arcpy.Describe(template).spatialReference
    # Open an insert cursor for the new feature class
    cur = arcpy.da.InsertCursor(outFC, ["SHAPE@"])
    # Create an array object needed to create features
    array = arcpy.Array()
    # Initialize a variable for keeping track of a feature's ID.
    ID = -1
    for coords in coords_list: 
        if ID == -1:
            ID = coords[0]
        # Add the point to the feature's array of points
        #   If the ID has changed, create a new feature
        if ID != coords[0]:
            cur.insertRow([arcpy.Polyline(array)])
            array.removeAll()
        array.add(arcpy.Point(coords[1], coords[2], ID=coords[0]))
        ID = coords[0]
    # Add the last feature
    polyline = arcpy.Polyline(array, spatial_reference)
    cur.insertRow([polyline])
except Exception as e:
    print(e)
finally:
    # Cleanup the cursor if necessary
    if cur:
        del cur
~~~

也可以根据坐标列表创建几何。这种方法可以提高性能，因为其可免除创建几何对象的消耗。但是，仅限于单部件要素；对于面要素，则没有内部环。所有坐标应该以要素类的空间参考为单位。

~~~python
import arcpy
import os
coordinates = [(-117.2000424, 34.0555514), 
               (-117.2000788, 34.0592066), 
               (-117.1957315, 34.0592309), 
               (-117.1956951, 34.0556001)]
# Create a feature class with a spatial reference of GCS WGS 1984
result = arcpy.management.CreateFeatureclass(
    arcpy.env.scratchGDB, 
    "esri_square", "POLYGON", spatial_reference=4326)
feature_class = result[0]
# Write feature to new feature class
with arcpy.da.InsertCursor(feature_class, ['SHAPE@']) as cursor:
    cursor.insertRow([coordinates])
~~~



### Numpy

~~~python
import arcpy import numpy
out_fc = 'C:/data/texas.gdb/fd/pointlocations'
# Create a numpy array with an id field, and a field with a tuple of x,y coordinates 
arr = numpy.array([(1, (471316.3835861763, 5000448.782036674)),                   (2, (470402.49348005146, 5000049.216449278))],                  numpy.dtype([('idfield', numpy.int32),('XY', '<f8', 2)]))

# Define a spatial reference for the output feature class 
spatial_ref = arcpy.Describe('C:/data/texas.gdb/fd').spatialReference

# Export the numpy array to a feature class using the XY field to
#  represent the output point feature 
arcpy.da.NumPyArrayToFeatureClass(arr, out_fc, ['XY'], spatial_ref)
~~~



### 验证（验证是否合法，并返回一个合法的值）

~~~python
ValidateTableName(name, {workspace})
~~~



### 使用 EGDB 连接执行 SQL

~~~python
import sys
import arcpy
try:
    arcpy.env.workspace = sys.path[0]
    egdb_conn = arcpy.ArcSDESQLExecute(r"data\Connection to GPSERVER3.sde")
    sql_statement = arcpy.GetParameterAsText(0)
    sql_statement_list = sql_statement.split(";")
    print("+++++++++++++++++++++++++++++++++++++++++++++\n")
    for sql in sql_statement_list:
        print("Execute SQL Statement: {0}".format(sql))
        try:
            egdb_return = egdb_conn.execute(sql)
        except Exception as err:
            print(err)
            egdb_return = False
        if isinstance(egdb_return, list):
            print("Number of rows returned by query: {0} rows".format(
                len(egdb_return)))
            for row in egdb_return:
                print(row)
            print("+++++++++++++++++++++++++++++++++++++++++++++\n")
        else:
            if egdb_return == True:
                print("SQL statement: {0} ran successfully.".format(sql))
            else:
                print("SQL statement: {0} FAILED.".format(sql))
            print("+++++++++++++++++++++++++++++++++++++++++++++\n")
except Exception as err:
    print(err)
~~~

使用事务

~~~python
# WARNING - DO NOT USE ON VERSIONED TABLES OR FEATURE CLASSES.
#   DO NOT USE ON ANY enterprise geodatabase SYSTEM TABLES.
#   DOING SO MAY RESULT IN DATA CORRUPTION.
import sys
import arcpy
try:
    # Make data path relative (not relevant unless data is moved
    # here and paths modified)
    arcpy.env.workspace = sys.path[0]
    # Column name:value that should be in the record.
    sql_values = {"STREET_NAM": "'EUREKA'"}
    # Value that is incorrect if found in the above column.
    bad_val = "'EREKA'"
    #List of tables to look in for the bad value.
    tables = ["streetaddresses_blkA", "streetaddresses_blkB",
              "streetaddresses_blkC"]
    # Two ways to create the object, which also creates the connection
    # to the enterprise geodatabase.
    # Using the first method, pass a set of strings containing the
    #   connection properties:
    #   <serverName>, <portNumber>, <version>, <userName>, <password>
    egdb_conn = arcpy.ArcSDESQLExecute("gpserver3", "5151", "#",
                                      "toolbox", "toolbox")
    # Using the second method pass the path to a valid enterprise geodatabase connection file
    #   arcpy.ArcSDESQLExecute("data\Connection to GPSERVER3.sde")
    for tbl in tables:
        print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        for col, val in list(sql_values.items()):
            print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
            # Check for the incorrect value in the column for the
            # specific rows. If the table contains the incorrect value,
            # correct it using the update SQL statement.
            print("Analyzing table {0} for bad data: "
                  "Column:{1} Value: {2}".format(tbl, col, bad_val))
            try:
                sql = "select OBJECTID,{0} from {1} where {0} = {2}".format(
                      col, tbl, bad_val)
                print("Attempt to execute SQL Statement: {0}".format(sql))
                egdb_return = egdb_conn.execute(sql)
            except Exception as err:
                print(err)
                egdb_return = False
            if isinstance(egdb_return, list):
                if len(egdb_return) > 0:
                    print("Identified {0} rows with incorrect data. Starting "
                          "transaction for update.".format(len(egdb_return)))
                    # Start the transaction
                    egdb_conn.startTransaction()
                    print("Transaction started...")
                    # Perform the update
                    try:
                        sql = "update {0} set {1}={2} where {1} = {3}".format(
                              tbl, col, val, bad_val)
                        print("Changing bad value: {0} to the good value: "
                              "{1} using update statement:\n {2}".format(
                              bad_val, val, sql))
                        egdb_return = egdb_conn.execute(sql)
                    except Exception as err:
                        print(err)
                        egdb_return = False
                    # If the update completed successfully, commit the
                    # changes.  If not, rollback.
                    if egdb_return == True:
                        print("Update statement: \n"
                              "{0} ran successfully.".format(sql))
                        # Commit the changes
                        egdb_conn.commitTransaction()
                        print("Committed Transaction")
                        # List the changes.
                        try:
                            print("Displaying updated rows for "
                                  "visual inspection.")
                            sql = "select OBJECTID" + \
                                  ",{0} from {1} where {0} = {2}".format(
                                  col, tbl, val)
                            print("Executing SQL Statement: \n{0}".format(sql))
                            egdb_return = egdb_conn.execute(sql)
                        except Exception as err:
                            print(err)
                            egdb_return = False
                        if isinstance(egdb_return, list):
                            print("{0} rows".format(len(egdb_return)))
                            for row in egdb_return:
                                print(row)
                            print("++++++++++++++++++++++++++++++++++++++++\n")
                        else:
                            if egdb_return == True:
                                print("SQL statement: \n{0}\n"
                                      "ran successfully.".format(sql))
                            else:
                                print("SQL statement: \n{0}\n"
                                      "FAILED.".format(sql))
                            print("++++++++++++++++++++++++++++++++++++++++\n")
                        print("++++++++++++++++++++++++++++++++++++++++\n")
                    else:
                        print("SQL statement: \n{0}\nFAILED. "
                              "Rolling back all changes.".format(sql))
                        # Rollback changes
                        egdb_conn.rollbackTransaction()
                        print("Rolled back any changes.")
                        print("++++++++++++++++++++++++++++++++++++++++\n")
            else:
                print "No records required updating."
    # Disconnect and exit
    del egdb_conn
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
except Exception as err:
    print(err)
~~~



### 数据列表

| 函数                                                         | 说明                                     |
| ------------------------------------------------------------ | ---------------------------------------- |
| [ListFields](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listfields.htm)(dataset, wild_card, field_type) | 返回在输入值中找到的字段的列表           |
| [ListIndexes](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listindexes.htm)(dataset, wild_card) | 返回在输入值中找到的属性索引的列表       |
| [ListDatasets](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listdatasets.htm)(wild_card, feature_type) | 返回当前工作空间中的数据集               |
| [ListFeatureClasses](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listfeatureclasses.htm)(wild_card, feature_type, feature_dataset) | 返回当前工作空间中的要素类               |
| [ListFiles](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listfiles.htm)(wild_card) | 返回当前工作空间中的文件                 |
| [ListRasters](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listrasters.htm)(wild_card, raster_type) | 返回在当前工作空间中找到的栅格数据的列表 |
| [ListTables](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listtables.htm)(wild_card, table_type) | 返回在当前工作空间中找到的表的列表       |
| [ListWorkspaces](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listworkspaces.htm)(wild_card, workspace_type) | 返回在当前工作空间中找到的工作空间的列表 |
| [ListVersions](https://pro.arcgis.com/zh-cn/pro-app/arcpy/functions/listversions.htm)(sde_workspace) | 返回已连接用户有权使用的版本的列表       |



### 字段映射

~~~python
import arcpy
from arcpy import env

env.workspace = "C:/Data/CityBlocks.gdb"
outfc = "C:/Data/CityBlocks.gdb/AllBlocks"

# Each of the input Feature classes has an STFID, which is the
#   combination of the Tract ID and Block ID for each block. 
#   Separate these values out from this field into two new
#   fields, TRACTID and BLOCKID.
#

# Create a fieldmappings and two new fieldmaps.
#
fieldmappings = arcpy.FieldMappings()
fldmap_TRACTID = arcpy.FieldMap()
fldmap_BLOCKID = arcpy.FieldMap()

# List all the feature classes in the workspace that start with 
#   'block' in their name and are of polygon feature type.
#
fcs = arcpy.ListFeatureClasses("block*", "Polygon")

# Create a value table that will hold the input feature classes to Merge
#
vTab = arcpy.ValueTable()
for fc in fcs:
    # Adding a table is the fast way to load all the fields from the
    #   input into fieldmaps held by the fieldmappings object.
    #
    fieldmappings.addTable(fc)

    # In this example also create two fieldmaps by 'chopping up'
    #   an input field. Feed the chopped field into the new fieldmaps.
    #
    fldmap_TRACTID.addInputField(fc, "STFID")
    fldmap_BLOCKID.addInputField(fc, "STFID")
		
    # Populate the input value table with feature classes
    #
    vTab.addRow(fc)

# Set the starting and ending position of the fields going into the
#   TractID fieldmap. This is the location in the STFID field where the
#   TractID falls.
#
for x in range(0, fldmap_TRACTID.inputFieldCount):
    fldmap_TRACTID.setStartTextPosition(x, 5)
    fldmap_TRACTID.setEndTextPosition(x, 10)

# Set the Name of the Field output from this field map.
#
fld_TRACTID = fldmap_TRACTID.outputField
fld_TRACTID.name = "TRACTID"
fldmap_TRACTID.outputField = fld_TRACTID

# Set the starting and ending position of the fields going into the
#   BlockID fieldmap. This is the location in the STFID field where the
#   blockID falls.
#
for x in range(0, fldmap_BLOCKID.inputFieldCount):
    fldmap_BLOCKID.setStartTextPosition(x, 11)
    fldmap_BLOCKID.setEndTextPosition(x, 16)

# Set the Name of the Field output from this field map.
#
fld_BLOCKID = fldmap_BLOCKID.outputField
fld_BLOCKID.name = "BLOCKID"
fldmap_BLOCKID.outputField = fld_BLOCKID

# Add the custom fieldmaps into the fieldmappings object.
#
fieldmappings.addFieldMap(fldmap_TRACTID)
fieldmappings.addFieldMap(fldmap_BLOCKID)

# Run the Merge tool.
#
arcpy.Merge_management(vTab, outfc, fieldmappings)
~~~

~~~python
import arcpy

outfc = "C:/data/CityData.gdb/AllBlocks"

# Want to merge these two feature classes together. Have a field
#   that has the same content but the names are slightly different:
#   Blocks1 has TRACT2000 and Blocks2 TRACTCODE. Name the output
#   the same as Blocks1.
#
fc1 = "C:/data/CityData.gdb/Blocks1"
fc2 = "C:/data/CityData.gdb/Blocks2"

# Create a new fieldmappings and add the two input feature classes.
#
fieldmappings = arcpy.FieldMappings()
fieldmappings.addTable(fc1)
fieldmappings.addTable(fc2)

# First get the TRACT2000 fieldmap. Then add the TRACTCODE field
#   from Blocks2 as an input field. Then replace the fieldmap within
#   the fieldmappings object.
#
fieldmap = fieldmappings.getFieldMap(fieldmappings.findFieldMapIndex("TRACT2000"))
fieldmap.addInputField(fc2, "TRACTCODE")
fieldmappings.replaceFieldMap(fieldmappings.findFieldMapIndex("TRACT2000"), fieldmap)

# Remove the TRACTCODE fieldmap.
#
fieldmappings.removeFieldMap(fieldmappings.findFieldMapIndex("TRACTCODE"))

# Create a value table that will hold the inputs for Merge.
#
vTab = arcpy.ValueTable()
vTab.addRow(fc1)
vTab.addRow(fc2)

# Run the Merge tool.
#
arcpy.Merge_management(vTab, outfc, fieldmappings)
~~~



## 服务发布

### （一）Web要素图层

~~~python
import arcpy
import os

# Sign in to portal
arcpy.SignInToPortal('https://www.arcgis.com', 'MyUserName', 'MyPassword')

# Set output file names
outdir = r"C:\Project\Output"
service = "FeatureSharingDraftExample"
sddraft_filename = service + ".sddraft"
sddraft_output_filename = os.path.join(outdir, sddraft_filename)

# Reference map to publish
aprx = arcpy.mp.ArcGISProject(r"C:\Project\World.aprx")
m = aprx.listMaps("World")[0]

# Create FeatureSharingDraft and set service properties
sharing_draft = m.getWebLayerSharingDraft("HOSTING_SERVER", "FEATURE", service)
sharing_draft.summary = "My Summary"
sharing_draft.tags = "My Tags"
sharing_draft.description = "My Description"
sharing_draft.credits = "My Credits"
sharing_draft.useLimitations = "My Use Limitations"

# Create Service Definition Draft file
sharing_draft.exportToSDDraft(sddraft_output_filename)

# Stage Service
sd_filename = service + ".sd"
sd_output_filename = os.path.join(outdir, sd_filename)
arcpy.StageService_server(sddraft_output_filename, sd_output_filename)

# Share to portal
print("Uploading Service Definition...")
arcpy.UploadServiceDefinition_server(sd_output_filename, "My Hosted Services")

print("Successfully Uploaded service.")
~~~

### （二）地图服务

#### 1、地图服务

~~~python
import arcpy
import os

# Set output file names
outdir = r"C:\Project\Output"
service = "MapServiceDraftExample"
sddraft_filename = service + ".sddraft"
sddraft_output_filename = os.path.join(outdir, sddraft_filename)

# Reference map to publish
aprx = arcpy.mp.ArcGISProject(r"C:\Project\World.aprx")
m = aprx.listMaps("World")[0]

# Create MapServiceDraft and set service properties
service_draft = arcpy.sharing.CreateSharingDraft("STANDALONE_SERVER", "MAP_SERVICE", service, m)
service_draft.targetServer = r"C:\Project\gisserver.ags.esri.com (publisher).ags"

# Create Service Definition Draft file
service_draft.exportToSDDraft(sddraft_output_filename)

# Stage Service
sd_filename = service + ".sd"
sd_output_filename = os.path.join(outdir, sd_filename)
arcpy.StageService_server(sddraft_output_filename, sd_output_filename)

# Publish to server
print("Uploading Service Definition...")
arcpy.UploadServiceDefinition_server(sd_output_filename, "https://gisserver.esri.com:6443/arcgis/")

print("Successfully Uploaded service.")
~~~

#### 2、切片的地图服务

~~~python
import arcpy, os, sys
import xml.dom.minidom as DOM

arcpy.env.overwriteOutput = True

# Update these variables
serviceName = "ModifySDDraftExample"
tempPath = r"C:\Project\Output"
path2APRX = r"C:\Project\World.aprx"
# Make sure this server url is added as publisher ags connection to the project
# Else use the ags connection file itself
targetServer = "https://gisserver.esri.com:6443/arcgis/"

# All paths are built by joining names to the tempPath
SDdraftPath = os.path.join(tempPath, "tempdraft.sddraft")
newSDdraftPath = os.path.join(tempPath, "updatedDraft.sddraft")
SDPath = os.path.join(tempPath, serviceName + ".sd")

aprx = arcpy.mp.ArcGISProject(path2APRX)
m = aprx.listMaps('World')[0]

# Create MapServiceDraft and set service properties
sddraft = arcpy.sharing.CreateSharingDraft('STANDALONE_SERVER', 'MAP_SERVICE', serviceName, m)
sddraft.targetServer = targetServer
sddraft.copyDataToServer = False
sddraft.exportToSDDraft(SDdraftPath)

# Read the contents of the original SDDraft into an xml parser
doc = DOM.parse(SDdraftPath)

# The following code modifies the SDDraft from a new MapService with caching capabilities
# to a FeatureService with Map, Create and Query capabilities.
typeNames = doc.getElementsByTagName('TypeName')
for typeName in typeNames:
    if typeName.firstChild.data == "FeatureServer":
        extention = typeName.parentNode
        for extElement in extention.childNodes:
            if extElement.tagName == 'Enabled':
                extElement.firstChild.data = 'true'

# Turn off caching
configProps = doc.getElementsByTagName('ConfigurationProperties')[0]
propArray = configProps.firstChild
propSets = propArray.childNodes
for propSet in propSets:
    keyValues = propSet.childNodes
    for keyValue in keyValues:
        if keyValue.tagName == 'Key':
            if keyValue.firstChild.data == "isCached":
                keyValue.nextSibling.firstChild.data = "false"

# Turn on feature access capabilities
configProps = doc.getElementsByTagName('Info')[0]
propArray = configProps.firstChild
propSets = propArray.childNodes
for propSet in propSets:
    keyValues = propSet.childNodes
    for keyValue in keyValues:
        if keyValue.tagName == 'Key':
            if keyValue.firstChild.data == "WebCapabilities":
                keyValue.nextSibling.firstChild.data = "Map,Query,Data"
                
# Modify keep cache, false by default
configProps = doc.getElementsByTagName('KeepExistingMapCache')[0]
configProps.firstChild.data = "true"
                
# Write the new draft to disk
f = open(newSDdraftPath, 'w')
doc.writexml(f)
f.close()

try:
    # Stage the service
    arcpy.StageService_server(newSDdraftPath, SDPath)
    warnings = arcpy.GetMessages(1)
    print(warnings)
    print("Staged service")

    # Upload the service
    arcpy.UploadServiceDefinition_server(SDPath, server_con)
    print("Uploaded service")

    # Manage Map server Cache Tiles
    # For cache, use multiple scales seperated by semicolon (;) 
    # For example "591657527.591555;295828763.795777" 
    arcpy.server.ManageMapServerCacheTiles(targetServer + os.sep + serviceName + ".MapServer", "591657527.591555",
    "RECREATE_ALL_TILES")
    
except Exception as stage_exception:
    print("Analyzer errors encountered - {}".format(str(stage_exception)))

except arcpy.ExecuteError:
    print(arcpy.GetMessages(2))
~~~



## 项目、地图、图层

### （一）项目 arpx文件（ArcGISProject）

#### 1、属性

| 属性                       | 说明                                                         | 数据类型                                                     |
| -------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| activeMap(只读)            | 返回与应用程序内部焦点视图相关联的[地图](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/map-class.htm)对象。如果布局视图处于活动状态，则其将返回与活动地图框相关联的[地图](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/map-class.htm)。注：该属性旨在通过使用脚本工具或 Python 窗口内的应用程序来执行。如果脚本在应用程序外部运行，则将始终返回 None。 | [Map](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/map-class.htm) |
| activeView(只读)           | 将返回 [MapView](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/mapview-class.htm) 或 [Layout](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layout-class.htm)，具体取决于当前视图。如果 ArcGIS Pro 工程未打开视图，或者活动视图为地图视图或布局视图之外的其他内容（例如，图表、表格、Model Builder 视图等），则将返回 None。注：该属性旨在通过使用脚本工具或 Python 窗口内的应用程序来执行。如果脚本在应用程序外部运行，则将始终返回 None。 | Object                                                       |
| dateSaved(只读)            | 返回报告上次工程保存日期的 Python datetime 对象。            | DateTime                                                     |
| defaultGeodatabase(可读写) | 工程的默认地理数据库位置。此字符串必须包含地理数据库的完整路径和文件名称。 | String                                                       |
| defaultToolbox(可读写)     | 工程的默认工具箱位置。此字符串必须包含工具箱的完整路径和文件名称。 | String                                                       |
| documentVersion(只读)      | 根据上次保存文档的时间返回文档版本。执行 save 或 saveACopy 将更新文档版本，以匹配应用程序版本。 | String                                                       |
| filePath(只读)             | 返回报告完全限定的工程路径和文件名的字符串值。               | String                                                       |
| homeFolder(可读写)         | 工程的主目录文件夹位置。此字符串必须包含所需位置的完整路径。 | String                                                       |
| metadata(可读写)           | 获取或设置工程的[元数据](https://pro.arcgis.com/zh-cn/pro-app/arcpy/metadata/metadata-class.htm)类信息。请注意：设置元数据取决于 isReadOnly 属性值。 | [Metadata](https://pro.arcgis.com/zh-cn/pro-app/arcpy/metadata/metadata-class.htm) |

#### 2、方法

| 方法                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| importDocument (document_path, {include_layout}, {reuse_existing_maps}) | 将地图文档 (.mxd)、globe 文档 (.3dd) 和 scene 文档 (.sxd) 导入到 ArcGIS Pro 工程中。还可以导入地图文件 (.mapx)、布局文件 (.pagx) 和报表文件 (.rptx) 的内容。 |
| listBrokenDataSources ()                                     | 返回项目中到所有地图原始源数据的连接存在断开情况的 [Layer](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layer-class.htm) 和/或 [Table](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/table-class.htm) 对象的 Python 列表。 |
| listColorRamps ({wildcard})                                  | listColorRamps 方法将引用工程中的可用色带。                  |
| listLayouts ({wildcard})                                     | 返回 ArcGIS 工程 (.aprx) 中的 [Layout](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layout-class.htm) 对象的 Python 列表。 |
| listMaps ({wildcard})                                        | 返回 ArcGIS 工程 (.aprx) 中的 [Map](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/map-class.htm) 对象的 Python 列表。 |
| listReports ({wildcard})                                     | 返回 ArcGIS 工程 (.aprx) 中的[报表](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/report-class.htm)对象的 Python 列表。 |
| save ()                                                      | 将更改保存至 ArcGISProject (.aprx)。                         |
| saveACopy (file_name)                                        | 将 ArcGISProject (.aprx) 保存到新文件路径或另存为新文件名。  |
| updateConnectionProperties (current_connection_info, new_connection_info, {auto_update_joins_and_relates}, {validate}, {ignore_case}) | 使用工作空间字典或路径替换连接属性。                         |

### （二）地图（Map）

#### 1、属性

| 属性                   | 说明                                                         | 数据类型                                                     |
| ---------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| defaultCamera(可读写)  | 用于获取或设置地图的默认[照相机](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/camera-class.htm)设置。注：修改 defaultCamera 将不会影响现有视图。仅当打开新的 [MapView](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/mapview-class.htm) 或将新的 [MapFrame](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/mapframe-class.htm) 插入布局中时，才会应用此属性。 | [Camera](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/camera-class.htm) |
| defaultView(只读)      | 与 Web 地图打印 Web 工具中的 [ConvertWebMapToArcGISProject](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/convertwebmaptoarcgisproject.htm) 一起使用，以返回要打印或导出的地图视图。 | [MapView](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/mapview-class.htm) |
| mapType(只读)          | 返回用于报告 Map 对象类型信息的字符串值。如果 Map 是 2D，则返回 MAP。如果 Map 是 3D，则返回 SCENE。 | String                                                       |
| mapUnits(只读)         | 返回用于表示为 Map 设置的地图单位的字符串值。                | String                                                       |
| metadata(可读写)       | 获取或设置地图的[元数据](https://pro.arcgis.com/zh-cn/pro-app/arcpy/metadata/metadata-class.htm)类信息。请注意：设置元数据取决于 isReadOnly 属性值。 | [Metadata](https://pro.arcgis.com/zh-cn/pro-app/arcpy/metadata/metadata-class.htm) |
| name(可读写)           | 用于在 Map 对象出现在内容列表中时获取或设置其名称，同时还用于获取或设置布局内的实际元素名称。 | String                                                       |
| referenceScale(可读写) | 用于获取或设置 Map 的参考比例。要清除最小比例，请将值设置为 0.0 | Double                                                       |

#### 2、方法概述

| 方法                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| addBasemap (basemap_name)                                    | addBasemap 可用于在地图内添加或替换底图图层。                |
| addDataFromPath (data_path)                                  | addDataFromPath 可通过提供本地路径或 URL 向工程中的地图 (.aprx) 添加[图层](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layer-class.htm)。 |
| addLayer (add_layer_or_layerfile, {add_position})            | 用于使用基本放置选项向工程 (.aprx) 内的地图添加 [Layer](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layer-class.htm) 或 [LayerFile](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layerfile-class.htm)。 |
| addLayerToGroup (target_group_layer, add_layer_or_layerfile, {add_position}) | 用于使用基本放置选项向工程 (.aprx) 内地图中的现有图层组添加 [Layer](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layer-class.htm) 或 [LayerFile](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layerfile-class.htm) 内容。 |
| addTable (add_table)                                         | 用于向工程 (.aprx) 内的地图中添加 [Table](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/table-class.htm)。 |
| clearSelection ()                                            | 清除地图中所有图层和表的选择。                               |
| getDefinition (cim_version)                                  | 获取地图的 CIM 定义。                                        |
| getWebLayerSharingDraft (server_type, service_type, service_name, {layers_and_tables}) | 在可配置并共享到 ArcGIS Enterprise 或 ArcGIS Online 的地图中创建共享草稿。 |
| insertLayer (reference_layer, insert_layer_or_layerfile, {insert_position}) | 用于通过指定特定位置向工程 (.aprx) 内的地图添加 [Layer](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layer-class.htm) 或 [LayerFile](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layerfile-class.htm)。 |
| listBookmarks ({wildcard})                                   | 返回 Map 中的 [bookmark](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/bookmark-class.htm) 对象的 Python 列表。 |
| listBrokenDataSources ()                                     | 返回地图中到原始源数据的连接存在断开情况的 [Layer](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layer-class.htm) 或 [Table](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/table-class.htm) 对象的 Python 列表。 |
| listLayers ({wildcard})                                      | 返回存在于地图中的 [Layer](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layer-class.htm) 对象的 Python 列表。 |
| listTables ({wildcard})                                      | 返回存在于地图中的 [Table](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/table-class.htm) 对象的 Python 列表。 |
| moveLayer (reference_layer, move_layer, {insert_position})   | 用于在图层堆叠中将地图中的图层或图层组移动到特定位置。       |
| removeLayer (remove_layer)                                   | 用于从工程内的地图中移除图层。                               |
| removeTable (remove_table)                                   | 用于从工程内的地图中移除表。                                 |
| setDefinition (definition_object)                            | 设置地图的 CIM 定义。                                        |
| updateConnectionProperties (current_connection_info, new_connection_info, {auto_update_joins_and_relates}, {validate}, {ignore_case}) | 使用工作空间字典或路径替换连接属性。                         |

### （三）图层（Layer）

#### 1、属性

| 属性                        | 说明                                                         | 数据类型                                                     |
| --------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| brightness(可读写)          | 图层的亮度值。默认的正常亮度是 0%。输入 +100% 和 -100% 之间的任意值。在值的左侧输入加号或减号以指定该值是大于零还是小于零。 | Integer                                                      |
| connectionProperties(只读)  | 图层数据源连接信息作为 Python 字典返回。                     | Dictionary                                                   |
| contrast(可读写)            | 图层的对比度值。默认的中性对比度是 0%。输入 +100% 和 -100% 之间的任意值。在值的左侧输入加号或减号以指定该值是大于零还是小于零。 | Integer                                                      |
| dataSource(只读)            | 返回图层数据源的完整路径。其中包含完整的工作空间路径和数据集名称。对于企业级地理数据库图层，将返回包含图层连接信息的字符串。提示：ArcGIS Pro 工程中的企业级地理数据库图层不保留用于创建图层的数据库连接文件的路径 (.sde)。 | String                                                       |
| definitionQuery(可读写)     | 图层的定义查询。                                             | String                                                       |
| is3DLayer(只读)             | 如果图层是 3D 图层，则返回 True。                            | Boolean                                                      |
| isBasemapLayer(只读)        | 如果图层是底图图层，则返回 True。                            | Boolean                                                      |
| isBroken(只读)              | 如果图层的数据源损坏，则返回 True。                          | Boolean                                                      |
| isFeatureLayer(只读)        | 如果图层是要素图层，则返回 True。                            | Boolean                                                      |
| isGroupLayer(只读)          | 如果图层是图层组，则返回 True。                              | Boolean                                                      |
| isNetworkAnalystLayer(只读) | 如果图层是 ArcGIS Network Analyst extension 图层，则返回 True。 | Boolean                                                      |
| isNetworkDatasetLayer(只读) | 如果图层是 ArcGIS Network Analyst extension 网络数据集图层，则返回 True。 | Boolean                                                      |
| isRasterLayer(只读)         | 如果图层是栅格图层，则返回 True。                            | Boolean                                                      |
| isSceneLayer(只读)          | 如果图层是场景图层，则返回 True。                            | Boolean                                                      |
| isWebLayer(只读)            | 如果图层是 GIS 服务图层，则返回 True。GIS 服务是自动化的地理信息服务，可以使用标准技术和协议在 Web 上对其进行发布和访问。例如 Esri 底图。 | Boolean                                                      |
| longName(只读)              | 包含图层组文件夹结构的图层完整路径。                         | String                                                       |
| maxThreshold(可读写)        | 图层的 2D 地图的最大比例阈值及其 3D 地图的地上最大距离。如果图层被放大的比例超过了最大比例，则不会显示出来。要清除最大比例，请将值设置为 0。 | Double                                                       |
| metadata(可读写)            | 获取或设置图层的[元数据](https://pro.arcgis.com/zh-cn/pro-app/arcpy/metadata/metadata-class.htm)类信息。请注意：设置元数据取决于 isReadOnly 属性值。 | [Metadata](https://pro.arcgis.com/zh-cn/pro-app/arcpy/metadata/metadata-class.htm) |
| minThreshold(可读写)        | 图层的 2D 地图的最小比例阈值及其 3D 地图的地上最大距离。如果图层被缩小的比例超过了最小比例，则不会显示出来。要清除最小比例，请将值设置为 0。 | Double                                                       |
| name(可读写)                | 图层在内容列表中显示的名称。可包含空格。有必要确保地图中的所有图层都具有唯一的名称，因为这样便可通过这些唯一名称轻松对其进行引用。 | String                                                       |
| showLabels(可读写)          | 控制图层标注的显示。如果设置为 True，则显示标注；如果设置为 False，则不会绘制标注。 | Boolean                                                      |
| symbology(可读写)           | 用于访问图层的[符号系统](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/symbology-class.htm)。 | Object                                                       |
| transparency(可读写)        | 图层的透明度值。这样即可看透图层。使用 0 和 100 之间的值。值 0 表示不透明。大于 90% 的透明度值经常导致图层几乎未被绘制。 | Integer                                                      |
| visible(可读写)             | 控制图层的显示。如果设置为 True，则绘制图层；如果设置为 False，则不绘制图层。 | Boolean                                                      |

#### 2、方法概述

| 方法                                                         | 说明                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| extrusion ({extrusion_type}, {expression})                   | 在图层中对 2D 要素进行拉伸以显示 3D 符号系统。               |
| getDefinition (cim_version)                                  | 获取图层 CIM 定义。                                          |
| getSelectionSet ()                                           | 以 Python 对象 ID 集的形式返回图层选择。                     |
| listLabelClasses ({wildcard})                                | 返回图层中的 [LabelClass](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/labelclass-class.htm) 对象的 Python 列表。 |
| listLayers ({wildcard})                                      | 返回图层文件中的 [Layer](https://pro.arcgis.com/zh-cn/pro-app/arcpy/mapping/layer-class.htm) 对象的 Python 列表。 |
| saveACopy (file_name)                                        | 将图层保存为图层文件 (.lyrx)。                               |
| setDefinition (definition_object)                            | 设置图层的 CIM 定义。                                        |
| setSelectionSet ({oidList}, {method})                        | 使用 Python 对象 ID 列表设置图层选择。                       |
| supports (layer_property)                                    | 用于确定特定图层类型是否支持图层对象上的属性。并非所有图层都支持同一组属性；尝试设置属性前可使用 supports 属性测试图层是否支持该属性。 |
| updateConnectionProperties (current_connection_info, new_connection_info, {auto_update_joins_and_relates}, {validate}, {ignore_case}) | 使用工作空间字典或路径替换连接属性。                         |
| updateLayerFromJSON (json_data)                              | 根据 JSON 字符串更新图层。                                   |



## 地理数据库的连接





















