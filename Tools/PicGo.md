# PicGo

[PicGo](https://picgo.github.io/PicGo-Doc/)

[PicGo: Github](https://github.com/Molunerfinn/PicGo)

[PicGo-Core](https://picgo.github.io/PicGo-Core-Doc/)

[PicGo-Core: Github](https://github.com/PicGo/PicGo-Core)

## 辅助

### PicGo + GitHub

> 由于gitee存在严格的审查制度，不方便图床的访问，所以采用了github作为图床仓库。

#### 1、创建 `Github` 的 `Token`

- 创建仓库
  
  勾选生成readme
  
  [Gearinger/GearSetting: 图床、gittalk、配置文件 (github.com)](https://github.com/Gearinger/GearSetting)

- 生成token
  
  setting - Developer settings - Generate new token - 勾选 repo

> Token：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

#### 2、安装 Picgo-core

> 需要 npm > 12.0 （管理员身份启动命令行）
> 
> 或者直接安装 picgo 桌面版，并把 exe 所在文件夹加入环境变量

```powershell
npm install picgo -g
```

#### 3、安装 picgo 插件

- super-prefix：重命名插件

```powershell
picgo install super-prefix
```

```json
"picgo-plugin-super-prefix": {
    "fileFormat": "YYYYMMDD-HHmmss"
}
```

- rename-file：重命名插件（由super-prefix改造而来）

[liuwave/picgo-plugin-rename-file: A PicGo plugin for elegant file name prefix (github.com)](https://github.com/liuwave/picgo-plugin-rename-file)

```json
"picgo-plugin-rename-file": {
    "format": "{y}/{m}/{d}/{hash}-{origin}-{rand:6}"
}
```

#### 整体配置

```json
{
  "picBed": {
    "uploader": "github",
    "current": "github",
    "github": {
      "repo": "Gearinger/GearSetting",
      "token": "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",
      "path": "picgo/",
      "branch": "main"
    }
  },
  "picgoPlugins": {
    "picgo-plugin-super-prefix": true
  },
  "picgo-plugin-super-prefix": {
    "fileFormat": "YYYYMMDD-HHmmss"
  }
}
```

> 完成上述操作后，picgo上传的图片就都在对应仓库中了
