# -*- encoding : utf-8 -*-
class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # validates :email, presence: true, format: { with:VALID_EMAIL_REGEX }#, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, :on => :create
  validates :login, presence: true, uniqueness: { case_sensitive: false }
  include AboutStatus
  # validates_with MyValidator, on: :update

  belongs_to :department

  # before_save {self.email = email.downcase}
  before_create :create_remember_token

  default_value_for :status, 65

  after_save do
    self.reset_menus_cache if self.menuids != "0" && self.changes["menuids"].present? && self.changes["menuids"].last.present?
  end
  # 为了在Model层使用current_user
  # def self.current
  #   Thread.current[:user]
  # end

  # def self.current=(user)
  #   Thread.current[:user] = user
  # end

  # 是否超级管理员,超级管理员不留操作痕迹
  def admin?
    false
    # self.roles.map(&:name).include?("系统管理员")
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end


  def self.status_array
    # [["正常", "65", "yellow", 100], ["已删除", "404", "dark", 100], ["已冻结", "12", "dark", 100]]
    self.get_status_array(["正常", "已冻结", "已删除"])
  end


  def self.xml(obj, current_u)
    %Q{
      <?xml version='1.0' encoding='UTF-8'?>
      <root>
        <node name='用户名' column='login' class='required' display='readonly'/>
        <node name='Email' column='email' class='email'/>
        <node name='姓名' column='name' class='required'/>
        <node name='电话' column='tel'/>
        <node name='手机' column='mobile' class='required'/>
        <node name='传真' column='fax'/>
        <node name='职务' column='duty'/>
      </root>
    }
  end

  # 根据action_name 判断obj有没有操作
  def cando(act='',current_u)
    case act
    when "show", "index", "only_show_info", "only_show_logs"
      self.department_id == current_u.department_id || current_u.is_boss?
    when "edit", "update", "reset_password", "update_reset_password"
      self.id == current_u.id || current_u.is_boss?
    when "recover", "update_recover"
      self.can_opt?("恢复")
    when "freeze", "update_freeze"
      self.can_opt?("冻结")
    when "simulate_login"
      current_u.is_boss?
    else false
    end
  end

  # 联系方式
  def tel_and_mobile
    [self.mobile, self.tel].select{|i| i.present?}.join(" / ")
  end

  def is_boss?
    Dictionary.daboss.include? self.login
  end


  private

    def create_remember_token
      self.remember_token=User.encrypt(User.new_remember_token)
    end
end
