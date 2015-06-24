fs      = require 'fs'
path    = require 'path'
gulp    = require 'gulp'
gutil   = require 'gulp-util'
color   = gutil.colors

helper = ->
    gutil.log color.yellow.bold "==========================="
    gutil.log color.yellow.bold "    前端独立控件开发构建框架    "
    gutil.log color.yellow.bold ""
    gutil.log color.cyan "为丰富前端的组件库，让所有前端同学可以根据项目需要，"
    gutil.log color.cyan "增加新的组件或功能时，保障组件的质量以及使用文档的完整性，"
    gutil.log color.cyan "特增加此独立控件开发构建框架。"
    gutil.log color.yellow.bold "==========================="
# 帮助
gulp.task 'helper', ->
    helper()

# 判断config.json是否存在，存在则重建
_cfgFile = path.join process.env.INIT_CWD,'config.json'
if !fs.existsSync(_cfgFile)
    gutil.log color.yellow "config.json is missing!"
    _cfg = {}
    _cfgData = JSON.stringify _cfg, null, 4
    fs.writeFileSync _cfgFile, _cfgData, 'utf8'
    gutil.log color.yellow "config.json rebuild success!"
    gutil.log color.green "Run Gulp Task again! Plzzzzz..."
    gulp.task 'default',[], ->
        helper()
    return false

_build  = require './lib/build'
setting = _build.setting
build   = _build.build
env     = setting.env

###
# ************* 构建任务函数 *************
###

gulp.task 'init',->
    build.init()

gulp.task 'cfg',->
    build.cfg()

gulp.task 'less',->
    build.less2js()

gulp.task 'tpl',->
    build.tpl2js()

gulp.task 'js',->
    build.js2dist()

gulp.task 'watch',->
    build.watch()

gulp.task 'default',->
    build.less2js ->
        build.tpl2js ->
            build.js2dist ->
                gulp.start 'watch'