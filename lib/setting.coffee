###
# v.build config
# @date 2014-12-2 15:10:14
# @author pjg <iampjg@gmail.com>
# @link http://pjg.pw
# @version $Id$
###

path  = require 'path'
cfg = require '../config.json'
args   = require('yargs').argv

_root = process.env.INIT_CWD

_env = (args.e or args.env) ? 'dev'


# 开发环境下，请求静态资源的域名

module.exports =

  # 开发环境 
  env: _env 

  # 扩展库的命名空间标志
  spaceName: "sbLib"

  # 生产目录
  root: _root
  distPath: './dist/'
  
  # 源码目录
  jsPath: './_src/'
  lessPath: './_src/_less/'
  tplPath: './_src/_tpl/'
  imgPath: './_src/img/'
  jsLibPath: './_src/vendor/'
  

  # 监控的文件
  watchFiles: [
      './_src/**/*.js'
      './_src/_less/**/*.less'
      './_src/_tpl/**/*.html'
      '!.DS_Store'
    ]
