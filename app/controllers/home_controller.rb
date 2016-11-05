# -*- encoding : utf-8 -*-
class HomeController < JamesController
  layout 'james', except: [:index]

  def index
    render layout: 'application'
  end

  # 全文检索
  def search
    return redirect_to root_path if params[:k].blank?
    @products = Product.search(params, {:page_num => 20})
  end

  def channel
    redirect_to not_found_path if params[:combo].blank?
    @category = Category.find_by id: params[:combo]
    @q = Product.show.where(["category_id = ?", params[:combo]]).ransack(params[:q])
    @products = @q.result.page params[:page]
  end

  def details
    @product = Product.find_by id: params[:pid]
    redirect_to not_found_path if @product.blank?
    @ps = Product.where(category_id: @product.category_id, psize: @product.psize, ptype: @product.ptype).where.not(id: @product.id).limit(4)
  end

  def hesay

  end

end
