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

st_root = process.env.INIT_CWD

_env = (args.e or args.env) ? 'dev'
_isDebug = (args.d or args.debug) ? false
_envs = cfg.envs


# 开发环境下，请求静态资源的域名

module.exports =

  # 开发环境 
  env: _env 

  # 是否开启debug模式
  isDebug: _isDebug

  # 生产目录
  distPath: './dist/'
  
  # 源码目录
  imgPath: './img/'
  jsPath: './_src/'
  lessPath: './_src/_less/'
  tplPath: './_src/_tpl/'
  jsLibPath: './_src/vendor/'
  
  # 一个大坑啊。。。
  watchFiles: [
      './_src/**/*.js'
      './_src/_less/**/*.less'
      './_src/_tpl/**/*.html'
      '!.DS_Store'
    ]
