# -*- encoding : utf-8 -*-
class Kobe::UsersController < KobeController

  before_action :get_user
  layout :false, :only => [:show, :edit, :reset_password, :invoice_info]
  skip_authorize_resource :only => [:simulate_login]

  def index
    @left_bar_arr = []
    @left_bar_arr << { url: edit_kobe_user_path(@user), icon: "fa-user", title: "修改个人信息" } if @user.cando("only_show_info", current_user)
    @left_bar_arr << { url: reset_password_kobe_user_path(@user), icon: "fa-paypal", title: "重置密码" } if @user.cando("reset_password", current_user)
    @left_bar_arr << { url: only_show_logs_kobe_user_path(@user), icon: "fa-history", title: "查看日志" } if @user.cando("read", current_user)
  end

  def edit
    @myform = SingleForm.new(User.xml(@user, current_user), @user, { form_id: "user_form", action: kobe_user_path(@user), method: "patch", grid: 2 })
  end

  def show
    @arr  = []
    @arr << { title: "详细信息", icon: "fa-info", content: show_obj_info(@user, User.xml(@user, current_user), grid: 1) }
    @arr << { title: "历史记录", icon: "fa-clock-o", content: show_logs(@user) }
  end

  def only_show_info
    render :text => show_obj_info(@user, User.xml(@user, current_user), grid: 1).html_safe
  end

  def only_show_logs
    render :text => show_logs(@user).html_safe
  end

  def reset_password
  end

  def update
    if update_and_write_logs(@user, User.xml(@user, current_user))
      redirect_to kobe_users_path
    else
      redirect_back_or
    end
  end

  def update_reset_password
    if @user.update(params.require(:user).permit(:password, :password_confirmation))
      write_logs(@user,"重置密码",'重置密码成功')
      tips_get("重置密码成功。")
      redirect_to kobe_users_path
    else
      flash_get(@user.errors.full_messages)
      redirect_back_or
    end
  end

  # 冻结
  def freeze
    render partial: '/shared/dialog/opt_liyou', locals: {form_id: 'freeze_user_form', action: update_freeze_kobe_user_path(@user)}
  end

  def update_freeze
    logs = stateless_logs("冻结用户", params[:opt_liyou], false)
    @user.change_status_and_write_logs("冻结",logs)
    tips_get("冻结用户成功。")
    redirect_to kobe_departments_path(id: @user.department.id)
  end

  # 恢复
  def recover
    render partial: '/shared/dialog/opt_liyou', locals: { form_id: 'recover_user_form', action: update_recover_kobe_user_path(@user) }
  end

  def update_recover
    @user.change_status_and_write_logs("恢复", stateless_logs("恢复",params[:opt_liyou],false))
    tips_get("恢复用户成功。")
    redirect_to kobe_departments_path(id: @user.department.id)
  end

  # 模拟登录
  def simulate_login
    rt = User.new_remember_token
    cookies[:remember_token] = rt
    @user.update remember_token: User.encrypt(rt)
    @current_user = @user
    redirect_to main_path
  end

  private

    def get_user
      @user = current_user
      cannot_do_tips unless @user.present? && @user.cando(action_name, current_user)
    end

end
