# -*- encoding : utf-8 -*-
class Kobe::ProductsController < KobeController

  before_action :get_category, :only => [:new, :create]
  before_action :get_product, :except => [:index, :new, :create]

  # 我的入围作品
  def index
    params[:q][:department_id_eq] = current_user.department_id unless current_user.is_boss?
    @q = Product.where(get_conditions("products", [["category_id = ?", params[:ca_id]]])).ransack(params[:q])
    @products = @q.result.page params[:page]
  end


  def new
    @product = Product.new
    @product.pcode = @category.code + create_random_chars(6)
    @myform = SingleForm.new(@category.params_xml, @product, { form_id: "product_form", upload_files: true, min_number_of_files: 1, action: kobe_products_path(ca_id: @category.id), title: "<i class='fa fa-pencil-square-o'></i> 发布作品", grid: 2 })
  end

  def create
    create_and_write_logs(Product, @category.params_xml, {}, { category_id: @category.id, department_id: current_user.department_id })
    redirect_to products_path(@category.id)
  end

  def update
    update_and_write_logs(@product, @product.category.params_xml, { action: '修改作品' })
    redirect_to products_path(@product.category_id)
  end

  def edit
    @myform = SingleForm.new(@product.category.params_xml, @product, { form_id: "product_form", upload_files: true, min_number_of_files: 1, action: kobe_product_path(@product), method: "patch", title: "<i class='fa fa-pencil-square-o'></i> 修改作品--#{@product.category.name}", grid: 2 })
  end

  def show
    @arr  = []
    @arr << { title: "详细信息", icon: "fa-info", content: show_obj_info(@product,@product.category.params_xml) }
    @arr << { title: "作品图片", icon: "fa-paperclip", content: show_uploads(@product, { is_picture: true }) }
    @arr << { title: "历史记录", icon: "fa-clock-o", content: show_logs(@product) }
  end


  # 删除
  # def delete
  #   render partial: '/shared/dialog/opt_liyou', locals: { form_id: 'delete_product_form', action: kobe_product_path(@product), method: 'delete' }
  # end

  def destroy
    @product.change_status_and_write_logs("删除", stateless_logs("删除", "", false))
    tips_get("删除成功。")
    redirect_back_or request.referer
  end

  # 下架
  # def freeze
  #   render partial: '/shared/dialog/opt_liyou', locals: {form_id: 'freeze_product_form', action: update_freeze_kobe_product_path(@product)}
  # end

  def update_freeze
    @product.change_status_and_write_logs("下架",stateless_logs("下架",  "", false))
    tips_get("下架成功。")
    redirect_back_or request.referer
  end

  # 恢复
  # def recover
  #   render partial: '/shared/dialog/opt_liyou', locals: { form_id: 'recover_product_form', action: update_recover_kobe_product_path(@product) }
  # end

  def update_recover
    @product.change_status_and_write_logs("恢复", stateless_logs("恢复", "", false))
    tips_get("恢复成功。")
    redirect_back_or request.referer
  end


  private

    def get_category
      @category = Category.find_by(id: params[:ca_id]) if params[:ca_id].present?
      cannot_do_tips if @category.blank?
    end

    def get_product
      @product = Product.find_by id: params[:id]
      cannot_do_tips unless @product.present? && @product.cando(action_name,current_user)
    end

end
