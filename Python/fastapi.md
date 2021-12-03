# FastAPI

## 一、环境部署

~~~sh
# 创建虚拟环境
virtualenv env

# 激活虚拟环境
cd env/bin
source activate

# 安装包
pip install fastapi
pip install uvicorn

~~~

## 二、创建API并运行

### 1、示例

创建main.py文件

~~~python
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Hello World"}
~~~

运行服务器

~~~python
uvicorn main:app --reload
~~~

相关地址

- api地址: http://127.0.0.1:8000

- 交互式 API 文档地址: http://127.0.0.1:8000/docs

- 可选的 API 文档地址: http://127.0.0.1:8000/redoc

另一种启动方式的示例

~~~python
from typing import Optional
import uvicorn
from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def read_root():
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Optional[str] = None):
    return {"item_id": item_id, "q": q}

if __name__ == '__main__':
    uvicorn.run(app='Main:app', host="127.0.0.1", port=8000, reload=True, debug=True)
~~~


