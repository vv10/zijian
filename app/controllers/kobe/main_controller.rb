# -*- encoding : utf-8 -*-
class Kobe::MainController < KobeController

  skip_load_and_authorize_resource

  def index
    @counters = Product.where(category_id: [2,1,5,4]).group(:category_id).count
    render layout: false
  end

end
