# 前端独立控件开发部署说明

## 最新版本
**0.0.1**

为丰富前端的组件库，让所有前端同学可以根据项目需要，增加新的组件或功能时，保障组件的质量以及使用文档的完整性，特增加此独立控件开发构建框架。

## 什么是独立控件
所谓独立控件，指的是一个最小化的，可独立的，并且功能完整的网页应用实现。它至少包含一个javascript和一份DEMO（html），此外，根据应用需要，开发者还可能要提供一份实现该应用的css样式。

## 独立控件的目录结构
```javascritp
./widget
    ├── base64
    ├── ...
    ├── layer
        ├── _src // 源码目录
            ├── less // layer.css.js的less源码
            ├── tpl  // layer.tpl.js的html源码
            ├── img  // 控件依赖的图片资源
            ├── layer.js
            ├── layer.css.js
            └── layer.tpl.js
        ├── dist // 生产目录
            ├── img
            ├── layer.js
            ├── layer.css.js
            ├── layer.tpl.js
            └── paths.json
        ├── demo.html // 独立控件的演示
        ├── config.json // 配置文件
        ├── gulpfile.js // gulp启动配置入口文件
        ├── package.json // nodeJS依赖安装的包管理文件
        ├── LICENSE-MIT
        └── README.md
```



## 安装控件的开发构建环境

比如要开发名为 `slide.js` 的控件，部署的步骤如下

首先，进入`libs`的目录，输入以下命令
```shell
git clone https://github.com/lmtdit/libder.git slide
```

稍等片刻，把开发构建框架`clone`到`slide`目录下，然后进入该目录，运行 `npm install`，来安装框架所需的依赖模块。
```shell
cd slide
npm install
```

> 关于NPM的知识，请参见[nodejs](http://nodejs.org/);

## 使用说明

### 初始化`config.json`配置
```json
{
    "hashLen": 10,
    "cdnDomain": "tmstatics.xxx.com"
}
```

### 项目初始化
```shell
gulp init
```

初始化的同时修改`package.json`的配置信息
```
//修改package里面的版本说明
gulp init --v 0.1.0

//修改package里面的模块说明
gulp init --desc 这是页面的独立控件。

//修改package里面的作者
gulp init --author pangjingui

//修改package里面的作者email
gulp init --email pangjg@shenba.com

// 所有信息一次修改
gulp init --v 0.1.0 --desc 这是页面的独立控件。 --author pangjingui --email pangjg@shenba.com
```

### 进入开发
```
gulp
```