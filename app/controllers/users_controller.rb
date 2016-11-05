# -*- encoding : utf-8 -*-
class UsersController < JamesController

  skip_before_action :verify_authenticity_token, :only => [:valid_dep_name, :valid_user_login, :valid_captcha, :valid_user]

  def sign_in
  end

  def sign_up
  end

  def forgot_password
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
    # tips_get '退出成功！'
    redirect_to sign_in_path
  end

  def login
    if session[:wrong_pwd]
      if verify_rucaptcha?
        check_user_pwd
      else
        flash_get '验证码错误!'
        redirect_to sign_in_path
      end
    else
      check_user_pwd
    end
  end

  # 注册 department表和user表占位子
  def create_user_dep
    dep = Department.create(name: params[:user][:dep], parent_id: Dictionary.dep_supplier_id, dep_type: false)
    user = User.create(params.require(:user).permit(:login, :email, :password, :password_confirmation))
    if dep.present? && user.present?
      user.update(department_id: dep.id)
      sign_in_user user
      write_logs(dep,"注册",'账号创建成功')
      write_logs(user,"注册",'账号创建成功')
      # UserMailer.registration_confirmation(user).deliver
      tips_get '账号创建成功！请完善资料'
      # 默认权限
      user.set_auto_menu
      redirect_to kobe_departments_path
    else
      msg = dep.errors.full_messages.blank? ? user.errors.full_messages : dep.errors.full_messages
      flash_get msg
      redirect_to sign_up_users_path
    end
  end

  def valid_dep_name
    render :text => valid_remote(Department, ["name = ? and dep_type is false and status <> 404", params.require(:user).permit(:dep)[:dep]])
  end

  def valid_user_login
    render :text => valid_remote(User, login: params.require(:user).permit(:login)[:login])
  end

  # # 验证码输入是否正确
  # def valid_captcha
  #   render :text => captcha_valid?(params.require(:user).permit(:captcha)[:captcha])
  # end

  # 验证用户名密码是否正确，不正确显示验证码
  # def valid_user
  #   user = User.find_by(login: params.permit(:user_name)[:user_name].downcase)
  #   if user && user.authenticate(params.require(:user).permit(:password)[:password])
  #     render :text => true
  #   else
  #     render :text => false
  #   end
  # end

  private

    def current_user=(user)
      @current_user = user
    end

    def sign_in_user(user,remember_me = false)
      remember_token = User.new_remember_token
      if remember_me
        cookies.permanent[:remember_token] = remember_token # 20年有效期
      else
        cookies[:remember_token] = remember_token # 30min 或关闭浏览器消失
      end
      user.update_attribute(:remember_token, User.encrypt(remember_token))
      self.current_user= user
    end

    # 登录验证用户名密码是否正确
    def check_user_pwd
      user_params = params.require(:user).permit(:login, :password, :remember_me)
      user = User.find_by(login: user_params[:login].downcase)
      if user && user.authenticate(user_params[:password])
        sign_in_user(user, user_params[:remember_me] == '1')
        session.delete(:wrong_pwd)
        # if user.department.get_tips.blank?
          # tips_get '登录成功！'
          redirect_to main_path
        # else
        #   flash_get user.department.get_tips
        #   redirect_to kobe_departments_path
        # end
      else
        session[:wrong_pwd] = true
        flash_get '用户名或者密码错误!'
        redirect_to sign_in_path
      end
    end

    # 验证码是否正确
    def check_captcha
      rucaptcha_at = session[:_rucaptcha_at].to_i
      captcha = (params[:_rucaptcha] || '').downcase.strip

      # Captcha chars in Session expire in 2 minutes
      valid = false
      if (Time.now.to_i - rucaptcha_at) <= RuCaptcha.config.expires_in
        valid = captcha.present? && captcha == session.delete(:_rucaptcha)
      end

      if resource && resource.respond_to?(:errors)
        resource.errors.add(:base, t('rucaptcha.invalid')) unless valid
      end

      valid
    end

end
