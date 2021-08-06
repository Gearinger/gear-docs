# ThreadPool

## 一、示例

```C#
// 传递任务状态
List<WaitHandle> waitHandles = new List<WaitHandle>();
// 遍历上传照片
string[] imageFiles = Directory.GetFiles(WorkspaceModel.ImagePath, "*.jpg");
bool pool = ThreadPool.SetMinThreads(8, 8);
if (pool)
{
    foreach (var imageFile in imageFiles)
    {
        ManualResetEvent wh = new ManualResetEvent(false);
        waitHandles.Add(wh);
        ThreadPool.QueueUserWorkItem(obj => Upload((ManualResetEvent)obj, imageFile), wh);
    }
}
// 等待所有任务执行完成
WaitHandle.WaitAll(waitHandles.ToArray());
WaitHelper.CloseWaiting();
```
```C#
private async void Upload(ManualResetEvent state, string imageFile)
{
    bool isSucceed = await OneImageUpload(imageFile);
    if (!isSucceed)
    {
        LogHelper.Error($"上传{imageFile}失败！");
        //throw new Exception($"上传{imageFile}失败！");
    }
    else
    {
        LogHelper.Info($"上传{imageFile}成功！");
    }
    // 设置状态为结束
    state.Set();
}
```