//= require plugins/jquery.min
//= require plugins/jquery-migrate-1.2.1.min
//= require plugins/bootstrap.min
//= require plugins/back-to-top
//= require plugins/smoothScroll
//= require app
//= require plugins/style-switcher
//

jQuery(document).ready(function() {
  // 初始化
  App.init();
  StyleSwitcher.initStyleSwitcher();
});
