define('lazyloadTpl',function(){var Lib=window.Lib||(window.Lib={});Lib.lazyloadTpl = {"_header":"<script id=\"tpl_header\" type=\"text/html\"><div class=\"logo\"><a href=\"#\" class=\"logo-expanded\"><img src=\"_img/logo@2x.png\" width=\"80\" alt=\"\" /></a><a href=\"#\" class=\"logo-collapsed\"><img src=\"_img/logo-collapsed@2x.png\" width=\"40\" alt=\"\" /></a></div><div class=\"mobile-menu-toggle visible-xs\"><a href=\"#\" data-toggle=\"user-info-menu\"><i class=\"fa-bell-o\"></i><span class=\"badge badge-success\">7</span></a><a href=\"#\" data-toggle=\"mobile-menu\" vm-click=\"mobileMenu\"><i class=\"fa-bars\"></i></a></div><div class=\"settings-icon\"><a href=\"#\" data-toggle=\"settings-pane\" data-animate=\"true\" vm-click=\"settingsPane\"><i class=\"linecons-cog\"></i></a></div></script>","_menu":"<script id=\"tpl_menu\" type=\"text/html\"><li class=\"active opened active\"><a href=\"dashboard-1.html\"><i class=\"linecons-cog\"></i><span class=\"title\">菜单一</span></a><ul><li><a href=\"dashboard-1.html\"><span class=\"title\">Dashboard 1</span></a></li><li><a href=\"dashboard-2.html\"><span class=\"title\">Dashboard 2</span></a></li></ul></li><li><a href=\"ui-widgets.html\"><i class=\"linecons-star\"></i><span class=\"title\">菜单二</span></a></li><li><a href=\"mailbox-main.html\"><i class=\"linecons-mail\"></i><span class=\"title\">菜单三</span><span class=\"label label-success pull-right\">5</span></a><ul><li><a href=\"mailbox-main.html\"><span class=\"title\">Inbox</span></a></li><li><a href=\"mailbox-compose.html\"><span class=\"title\">Compose Message</span></a></li><li><a href=\"mailbox-message.html\"><span class=\"title\">View Message</span></a></li></ul></li><li><a href=\"extra-gallery.html\"><i class=\"linecons-beaker\"></i><span class=\"title\">菜单四</span><span class=\"label label-purple pull-right hidden-collapsed\">New Items</span></a><ul><li><a href=\"extra-icons-fontawesome.html\"><span class=\"title\">Icons</span><span class=\"label label-warning pull-right\">4</span></a><ul><li><a href=\"extra-icons-fontawesome.html\"><span class=\"title\">Font Awesome</span></a></li><li><a href=\"extra-icons-linecons.html\"><span class=\"title\">Linecons</span></a></li><li><a href=\"extra-icons-elusive.html\"><span class=\"title\">Elusive</span></a></li><li><a href=\"extra-icons-meteocons.html\"><span class=\"title\">Meteocons</span></a></li></ul></li><li><a href=\"extra-maps-google.html\"><span class=\"title\">Maps</span></a><ul><li><a href=\"extra-maps-google.html\"><span class=\"title\">Google Maps</span></a></li><li><a href=\"extra-maps-advanced.html\"><span class=\"title\">Advanced Map</span></a></li><li><a href=\"extra-maps-vector.html\"><span class=\"title\">Vector Map</span></a></li></ul></li><li class=\"active\"><a href=\"extra-gallery.html\"><span class=\"title\">Gallery</span></a></li><li><a href=\"extra-calendar.html\"><span class=\"title\">Calendar</span></a></li></ul></li><li><a href=\"#\"><i class=\"linecons-cloud\"></i><span class=\"title\">菜单五</span></a><ul><li><a href=\"#\"><i class=\"entypo-flow-line\"></i><span class=\"title\">二级菜单</span></a><ul><li><a href=\"#\"><i class=\"entypo-flow-parallel\"></i><span class=\"title\">三级菜单</span></a></li><li><a href=\"#\"><i class=\"entypo-flow-parallel\"></i><span class=\"title\">三级菜单</span></a><ul><li><a href=\"#\"><i class=\"entypo-flow-cascade\"></i><span class=\"title\">四级菜单</span></a></li><li><a href=\"#\"><i class=\"entypo-flow-cascade\"></i><span class=\"title\">四级菜单</span></a><ul><li><a href=\"#\"><i class=\"entypo-flow-branch\"></i><span class=\"title\">五级菜单</span></a></li></ul></li></ul></li><li><a href=\"#\"><i class=\"entypo-flow-parallel\"></i><span class=\"title\">三级菜单</span></a></li></ul></li><li><a href=\"#\"><i class=\"entypo-flow-line\"></i><span class=\"title\">二级菜单</span></a></li><li><a href=\"#\"><i class=\"entypo-flow-line\"></i><span class=\"title\">二级菜单</span></a></li></ul></li></script>","main":"<div class=\"sidebar-menu-inner\"><header id=\"logo-env\" class=\"logo-env\" vm-include=\"tpl_header\" data-include-rendered=\"render\"></header><ul id=\"main-menu\" class=\"main-menu\" vm-include=\"tpl_menu\" data-include-rendered=\"render\"></ul></div>","test":"<div class=\"test\"> {{el.html}}</div>"};return Lib;});