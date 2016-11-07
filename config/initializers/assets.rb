# -*- encoding : utf-8 -*-
# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# *.png *.jpg *.jpeg *.gif
Rails.application.config.assets.precompile += %w(style-switcher.css common.css *.png *.jpg *.jpeg *.gif ie_9.js form.js kobe.js kobe.css james.js james.css plugins/jquery.backstretch.min.js channel.css channel.js base.css base.js user.css plugins/cube-portfolio/cube-portfolio-4.js plugins/cube-portfolio/cube-portfolio-8.js)
