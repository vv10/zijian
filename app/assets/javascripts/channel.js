//= require base
//= require plugins/cube-portfolio/jquery.cubeportfolio.min

//= require pubu/masonry.pkgd.min
//= require pubu/imagesloaded.pkgd.min

//= require plugins/viewer.min

// require plugins/jquery.lazyload.min


$(function() {

    var $container = $('#masonry');
    $container.imagesLoaded(function() {
        $container.masonry({
                itemSelector: '.box',
                gutter: 10,
                isAnimated: true,
            });
     });

	// $("img.lazy").lazyload();

	// 看大图
	$('.channel').viewer({url: 'data-original'});
});
