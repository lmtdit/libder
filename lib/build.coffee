fs      = require 'fs'
path    = require 'path'
_       = require 'lodash'
gulp    = require 'gulp'
gutil   = require 'gulp-util'
less    = require 'gulp-less'
mincss  = require 'gulp-minify-css'
plumber = require 'gulp-plumber'
watch   = require 'gulp-watch'
rjs     = require 'gulp-requirejs'
uglify  = require 'gulp-uglify'
rename  = require 'gulp-rename'
amdclean = require 'amdclean'
setting = require './setting'
color   = gutil.colors

pkg = require('../package.json')
_modName = pkg.name
###
# base functions
###
Tools = 
    # md5
    md5: (text) ->
        crypto.createHash('md5').update(text).digest('hex')
    # make dir 
    mkdirsSync: (dirpath, mode)->
        if fs.existsSync(dirpath)
            return true
        else
            if Tools.mkdirsSync path.dirname(dirpath), mode
                fs.mkdirSync(dirpath, mode)
                return true
    # 合并对象或数组
    objMixin: _.partialRight _.assign, (a, b) ->
        val = if (typeof a is 'undefined') then b else a
        return val
    # 执行命令
    exec: (command, callback)->
        exec command,(error, stdout, stderr)->
            # console.log(command + ' 执行中...')
            if stdout
                console.log('exec stdout: ' + stdout)
            if stderr
                console.log('exec stderr: ' + stderr)
            if error
                console.log('exec error: ' + error)
            # console.log(command + ' 执行完毕！')
            callback and callback() 
    errHandler:(e)->
        gutil.beep()
        gutil.beep()
        gutil.log e
    htmlMinify:(source)->
        return source
            .replace(/<!--([\s\S]*?)-->/g, '')
            .replace(/\/\*([\s\S]*?)\*\//g, '')
            .replace(/^\s+$/g, '')
            .replace(/\n/g, '')
            .replace(/\t/g, '')
            .replace(/\r/g, '')
            .replace(/\n\s+/g, ' ')
            .replace(/\s+/g, ' ')
            .replace(/>([\n\s+]*?)</g,'><')


###
# js 生产文件处理函数
# @param {string} files 接收一个路径参数，同gulp.src
# @param {function} cb 处理过程中，处理一个buffer流的回调
# @param {function} cb2 所有buffer处理完成后的回调函数
###
_paths = {}
class jsCtl
    _jsPath: setting.jsPath
    _distPath: setting.distPath
    amdReg: /define\s*\(([^(]*),?\s*?function\s*\([^\)]*\)\s*\{/
    expStr: /define\s*\(([^(]*),?\s*?function/
    depArrReg: /^[^\[]*(\[[^\]\[]*\]).*$/
    filter:['less','tpl','vendor']

    tryEval: (str)-> 
        try 
            json = eval('(' + str + ')')
        catch err

    # 过滤依赖表里的关键词，排除空依赖 
    filterDepMap: (depMap)->
        arr = []
        filter = ["require", "exports", "module", ""]
        for key in depMap
            if key not in filter
                arr.push key
        return arr

    # 将绝对路径转换为AMD模块ID
    madeModId: (filepath)->
        return filepath.replace(/\\/g,'/')
                       .split('/js/')[1]
                       .replace(/.js$/,'')

    # 将相对路径转换为AMD模块ID
    madeModList: (depArr,curPath)->
        _arr = []
        # console.log depArr
        if depArr.length > 0
            for val in depArr
                _val = val
                if _val.indexOf('../') is 0 or _val.indexOf('./') is 0
                    _filePath = path.join curPath,_val
                    _val = @madeModId _filePath
                _arr.push _val
        return _arr
        
    # 将js数组转字符串
    arrToString: (arr)->
        _str = ""
        if arr.length > 0
            _.forEach arr,(val,n)->
                _str += (if n > 0 then "," else "") + "'#{val}'"
        return "[#{_str}]"

    # 给匿名AMD模块添加ID
    _stream: (files,cb,cb2)->
        _this = @
        gulp.src [files]
            .pipe plumber({errorHandler: Tools.errrHandler})
            .on 'data',(source)->
                _list = []
                _filePath = source.path.replace(/\\/g,'/')
                _nameObj = path.parse _filePath
                _modId = _this.madeModId(_filePath)
                _source = String(source.contents)
                if _filePath.indexOf("/vendor/") is -1
                    _source = _source.replace _this.amdReg,(str,map)->
                        _depStr = map.replace _this.depArrReg, "$1"
                        if /^\[/.test(_depStr)
                            _arr = _this.tryEval _depStr
                            try 
                                _arr = _this.filterDepMap(_arr)
                                # console.log _nameObj 
                                _list = _this.madeModList(_arr,_nameObj.dir)
                                _str = _this.arrToString _list
                                return str.replace(_this.expStr, "define('#{_modId}',#{_str},function")
                            catch error
                        else
                            return str.replace(_this.expStr, "define('#{_modId}',function")
                    # _source = amdclean.clean({
                    #         code:_source
                    #         wrap:null
                    #     })
                    # console.log _source

                cb(_nameObj,_source)
            .on 'end',cb2
    
    # 文件写入磁盘
    _buildJs: (name,source)->
        _file = path.join(@_distPath, name)
        Tools.mkdirsSync(path.dirname(_file))
        fs.writeFileSync _file, source, 'utf8'

    ###
    # Build AMDmodule with ID
    # @param {string} file 同gulp.src接口所接收的参数，默认是js debug目录中的所有js文件
    # @param {function} done 回调函数
    ###
    init: (file,done)=>
        gutil.log "Build js..."
        if typeof file is 'function'
            _done = file
            _file = @_jsPath + '**/*.js'
        else
            _file = file or @_jsPath + '**/*.js'
            _done = done or ->
        _this = @
        _num = 0
        @_stream(
            _file
            (obj,source)->
                # console.log obj
                _paths[obj.name] = "dist/#{obj.name}"
                _source = source
                _dir = obj.dir.split("/js/")[1]
                _distname = obj.name + obj.ext
                _dir and (_distname = _dir + '/' + _distname)
                if _num%20 == 0 and _num > 15
                    gutil.log 'Building...'
                _this._buildJs _distname,_source
                _num++
            ->
                gutil.log 'Build success!'
                _done()
        )

    # 合并AMD模块
    combo: (cb)=>
        _baseUrl = './'
        _main = "js/#{pkg.name}.js"
        _outName = "#{pkg.name}.js"
        rjs
            baseUrl: _baseUrl
            name: _main
            out: _outName
        
        .on 'data',(output)->
            _source = String(output.contents)
            # console.log _source
        .pipe gulp.dest('./dist/')
        .pipe uglify()
        .pipe rename({
                suffix: ".min",
                extname: ".js"
              })
        .pipe gulp.dest('./dist/')
        .on 'end',->
                cb and cb()

# 构建方法
build =
    # project init
    init: ->
        init_dir = [
            setting.lessPath
            setting.jsPath
            setting.imgPath
            setting.tplPath
            # setting.jsLibPath
            # setting.distPath
        ]
        for _dir in init_dir
            Tools.mkdirsSync _dir
            gutil.log "#{_dir} made success!"
        _mainFile = path.join setting.jsPath,_modName + '.js'
        if !fs.existsSync(_mainFile)
            _jsData = "define(function(){\n\tvar Lib = window.Lib || (window.Lib = {});\n\t/*code here*/\n\t\n\tLib.#{_modName}=#{_modName};\n\treturn Lib;\n});"
            fs.writeFileSync _mainFile, _jsData, 'utf8'
        gutil.log color.cyan "#{_modName} init success!"
        
    # build less to js
    less2js: (cb)->
        _lessPath = setting.lessPath
        _less = (lessFile,cb)->
            _source = {}
            gulp.src(lessFile)
                .pipe plumber({errorHandler: Tools.errHandler})
                .pipe less
                        compress: false
                .pipe mincss({
                        keepBreaks:false
                        compatibility:
                            properties:
                                iePrefixHack:true
                                ieSuffixHack:true
                    })
                .on 'data',(output)->
                    _fileName = path.basename(output.path,'.css')
                    _source[_fileName] = output.contents.toString()
                .on 'end',-> 
                    cb and cb(_source)
        _files = []
        fs.readdirSync(_lessPath).forEach (f)->
            if f.indexOf('.') != 0 and f.indexOf('.less') != -1
                _lessFile = path.join(_lessPath, f)
                _files.push _lessFile
        _less _files,(datas)->
            css_source = "define(function(){var Lib=window.Lib||(window.Lib={});Lib.#{_modName}Css = #{JSON.stringify(datas)};return Lib;});"
            fs.writeFileSync path.join(setting.jsPath,"#{_modName}Css.js"), css_source, 'utf8'
            gutil.log 'lessTojs done!'
            cb and cb()

    # build html tpl to js 
    tpl2js: (cb)->
        _htmlMinify = Tools.htmlMinify
        _tplPath = setting.tplPath
        tplData = {}
        fs.readdirSync(_tplPath).forEach (file)->
            _file_path = path.join(_tplPath, file)
            if fs.statSync(_file_path).isFile() and file.indexOf('.html') != -1 and file.indexOf('.') != 0
                _fileName = path.basename(file,'.html')
                _source = fs.readFileSync(_file_path, 'utf8')
                # console.log _fileName
                # 压缩html
                file_source = Tools.htmlMinify(_source)

                if file.indexOf('_') == 0
                  tplData[_fileName] = "<script id=\"tpl#{_fileName}\" type=\"text/html\">#{file_source}</script>"
                else
                  tplData[_fileName] = file_source
        tpl_soure = "define(function(){var Lib=window.Lib||(window.Lib={});Lib.#{_modName}Tpl = #{JSON.stringify(tplData)};return Lib;});"
        fs.writeFileSync path.join(setting.jsPath,"#{_modName}Tpl.js"), tpl_soure, 'utf8'
        gutil.log 'tplTojs done!'
        cb and cb()

    # build paths
    paths:(obj)->
        _Data = JSON.stringify obj, null, 2
        fs.writeFileSync path.join(setting.distPath, "paths.json"), _Data, 'utf8'
        gutil.log 'paths.json done!'

    # build requireJs config
    cfg:(obj)->
        config = require '../config.json'

        _distPath = setting.distPath

        # 读取json配置
        myPaths = obj or require '../dist/paths.json'

        # 预留给第三方的js插件的接口
        
        shimData = config.shim
        jsPaths = config.paths

        # 过滤核心库
        newPaths = {}
        for key,val of jsPaths
            if key isnt 'require'
                newPaths[key] = val
        rCfg =
            baseUrl: './'
            paths: _.assign newPaths,myPaths
            shim: shimData
            
        jsSrcPath = config.jsSrcPath
        require_cfg = "require.config(#{JSON.stringify(rCfg, null, 2)});"
        fs.writeFileSync path.join('.', "require_cfg.js"), require_cfg, 'utf8'
        gutil.log 'require_cfg.js done!'

    # build js to dist dir
    js2dist:(cb)->
        _this = @
        _cb = cb or ->
        new jsCtl().init ->
            # console.log _paths
            _this.paths(_paths)
            _this.cfg(_paths)
            _cb()
    _getType:(dir)->
        type = ''
        if dir.indexOf('_tpl') > 0
            type = 'tpl'
        else if dir.indexOf('_less') > 0
            type = 'less'
        else
            type = 'js'
        return type
    watch:->
        _this = @
        _list = []
        _watchFiles = setting.watchFiles
        watch _watchFiles,(file)->
            try
                _event = file.event
                if _event isnt 'undefined'
                    _file_path = file.path.replace(/\\/g,'/')
                    _parse = path.parse _file_path
                    # console.log _parse
                    _type = _this._getType(_parse.dir)
                    _list.push(_type) if _type not in _type
                    switch _type
                        when 'js'
                            new jsCtl().init()
                        when 'less'
                            _this.less2js()
                        when 'tpl'
                            _this.tpl2js()
                # clear watch list after 3 seconds
                clearTimeout watch_timer if watch_timer
                watch_timer = setTimeout ->
                    
                    _list = []
                ,3000
            catch err
                console.log err 
exports.setting = setting
# exports.Tools = Tools
exports.build = build