//= require base
//= require plugins/cube-portfolio/jquery.cubeportfolio.min

//= require pubu/modernizr.custom
//= require pubu/masonry.pkgd.min
//= require pubu/imagesloaded
//= require pubu/classie
//= require pubu/AnimOnScroll

//= require plugins/viewer.min
//
//= require plugins/jquery.lazyload.min

$(function() {

	new AnimOnScroll( document.getElementById( 'grid' ), {
		minDuration : 0.4,
		maxDuration : 0.7,
		viewportFactor : 0.2
	} );

	$('.channel').viewer();
});
