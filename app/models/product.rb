# -*- encoding : utf-8 -*-
class Product < ActiveRecord::Base
  has_many :uploads, class_name: :ProductsUpload, foreign_key: :master_id
  belongs_to :category
  belongs_to :department

  scope :show, -> { where(status: Product.effective_status) }

  include AboutStatus

  default_value_for :status, 65


  # 全文检索
  if Rails.env.production?
    searchable do
      text :pcode, :stored => true, :boost => 10.0
      text :title, :stored => true, :boost => 10.0
      text :ptype, :stored => true, :boost => 10.0
      text :psize, :stored => true, :boost => 10.0
      text :pkey, :stored => true, :boost => 10.0

      text :category do
        category.name if category
      end
      text :department do
        department.name if department
      end
      integer :department_id
      integer :category_id
      integer :status
      time :created_at
      time :updated_at
      integer :id
    end
  end

  def self.search(params = {}, options = {})
    options[:page_num] ||= 30
    if options[:all]
      options[:page_num] = Sunspot.search(Product).total
      params[:page] = 1
    end
    # options[:show] ||= 1
    conditions = Proc.new{
      fulltext params[:k] do
        highlight :pcode
        highlight :title
        highlight :ptype
        highlight :psize
        highlight :pkey

      end if params[:k].present?
      with(:status, self.effective_status)
      # with(:show, options[:show]) if options[:show].present?
      order_by :id
      paginate :page => params[:page], :per_page => options[:page_num]
    }
    Sunspot.search(Product, &conditions)
  end

  # 附件的类
  def self.upload_model
    ProductsUpload
  end

  # 照片
  def picture
    self.uploads.first
  end

  def show
    Product.effective_status.include?(self.status)
  end

  # 中文意思 状态值 标签颜色 进度
  def self.status_array
    self.get_status_array(["正常", "已下架", "已删除"])
    # [
    #   ["未提交",0,"orange",10],
    #   ["正常",1,"u",100],
    #   ["等待审核",2,"blue",50],
    #   ["审核拒绝",3,"red",0],
    #   ["已下架",4,"yellow",20],
    #   ["已删除",404,"light",0]
    # ]
  end

  # 根据action_name 判断obj有没有操作
  def cando(act='',current_u=nil)
    case act
    when "show", "update", "edit", "delete", "destroy", "recover", "update_recover", "freeze", "update_freeze"
      # 上级单位或者总公司人
      current_u.department_id == self.department_id || current_u.is_boss?
    else false
    end
  end

end
