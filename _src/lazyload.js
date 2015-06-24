/**
 * img lazyloaded
 *
 * - background img
 * - img
 *
 * To change this template use File | Settings | File Templates.
 *  how to use
 *  Lazyload.init();
 *  if inited
 *  Lazyload.trigger();
 * @todo 替换error图片
 */
define(['./lazyloadCss','./lazyloadTpl'],function() {
    var Lib = window.Lib || (window.Lib = {});
    // var _css = {{css}};
    // var _tpl = {{tpl}};
    var iPhone = navigator.appVersion.match(/(iPhone\sOS)\s([\d_]+)/),
        version = iPhone && iPhone[2].split('_');
    version = version && parseFloat(version.length > 1 ? version.splice(0, 2).join(".") : version[0], 10);

    var phoneType = version && (version < 6);

    var Lazyload = {

        defaultOpts: {
            loadHidden: true,
            interval: 200,
            threshold: 5,
            errorImg: 'http://pcstatics.shenba.com/assets/img/dot.png',
            container: null
        },

        init: function(opts) {
            this.options = $.extend(true, {}, this.defaultOpts, opts);

            this.addEvent();
            this.trigger();
        },

        addEvent: function() {
            var self = this,
                opts = this.options;

            if (phoneType) {
                var params = {},
                    timeout = null;

                $(window).on('touchstart', function(e) {
                    params = {
                        scrollY: window.scrollY,
                        time: Date.now()
                    };

                    timeout && clearTimeout(timeout);
                }).on('touchend', function(e) {
                    if (e && e.changedTouches) {
                        var dist = Math.abs(window.scrollY - params.scrollY);

                        if (dist > opts.threshold) {
                            var inter = Date.now() - params.time;

                            timeout = setTimeout(function() {
                                self.update();
                                params = {};
                                clearTimeout(timeout);
                                timeout = null;
                            }, inter > opts.interval ? 0 : 200);
                        }

                    } else {
                        self.update();
                    }
                }).on("touchcancel", function() {
                    timeout && clearTimeout(timeout);
                    params = {};
                })
            } else {
                var $container = self.options.container ? $(self.options.container) : $(window);
                $container.on('scroll', function() {
                    self.update();
                })
            }
        },

        trigger: function() {
            var self = this,
                opts = this.options,
                evtType = phoneType && "touchend" || "scroll";

            self.prevlist && self.prevlist.each(function(index, item) {
                item && (item.onerror = item.onload = null)
            });
            self.imglist = $(".lazy");

            // copy object trick way
            self.prevlist = $.extend({}, true, self.imglist);
            $(window).trigger(evtType);
        },

        inviewport: function(item, t) {
            var offsetY = window.pageYOffset,
                pageHeight = window.pageYOffset + window.innerHeight,
                itemTop = item.offset().top;
            return itemTop >= offsetY && itemTop + (t || -100) <= pageHeight;
        },

        // update img dom
        update: function() {
            var self = this;
            var opts = this.options;

            self.imglist.each(function(index, item) {
                var hidden = !opts.loadHidden ? $(item).is(":hidden") : false;
                if (item && self.inviewport($(item)) && !hidden) {
                    var $item = $(item);
                    var src = $item.attr('dataimg');
                    var isImg = $item[0].tagName.toLowerCase() === 'img';

                    var img = new Image();
                    img.src = src;

                    img.onload = function() {
                        self.imglist[index] = null;

                        $item.removeClass('lazy').removeAttr('dataimg');
                        if (isImg) {
                            $item.attr('src', src);
                        } else {
                            $item.css('background-image', 'url(' + src + ')');
                        }
                        img.onload = img.onerror = null;
                    }

                    img.onerror = function() {
                        self.imglist[index] = null;
                        $item.removeClass('lazy').removeAttr('dataimg');
                        if (isImg) {
                            $item.attr('src', opts.errorImg);
                        } else {
                            $item.css('background-image', 'url(' + opts.errorImg + ')');
                        }
                        img.onload = img.onerror = null;
                    }

                } else {
                    return;
                }

            })
        }

    }
    Lib.Lazyload = Lazyload;
    return Lib;
});
