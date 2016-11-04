# -*- encoding : utf-8 -*-
# 前台布局
class JamesController < ApplicationController

  before_action :default_search

  # 搜索默认值 默认搜索产品
  def default_search
    params[:t] ||= "search_products"
  end

end
