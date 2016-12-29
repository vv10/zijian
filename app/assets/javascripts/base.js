//= require plugins/jquery.min
//= require plugins/jquery-migrate-1.2.1.min
//= require plugins/bootstrap.min
//= require plugins/back-to-top
//= require plugins/smoothScroll
//= require app
//= require plugins/style-switcher
//= require plugins/jquery.lazyload.min.js
//

jQuery(document).ready(function() {
  // 初始化
  App.init();
  StyleSwitcher.initStyleSwitcher();

  // 图片懒加载
  $("img.lazy").lazyload();
});
