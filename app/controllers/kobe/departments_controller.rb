# -*- encoding : utf-8 -*-
class Kobe::DepartmentsController < KobeController
  skip_before_action :verify_authenticity_token, :only => [:move, :valid_dep_name, :commit, :edit_bank, :search_bank]
  before_action :get_audit_menu_ids, :only => [:list, :audit, :update_audit]
  before_action :get_dep, :except => [:valid_dep_name, :search_bank, :move, :new, :create, :search, :list]
  layout :false, :only => [:show, :edit, :new, :add_user, :delete, :freeze, :recover, :upload, :commit, :show_bank, :edit_bank, :search_bank]

  # cancancan验证 如果有before_action cancancan放最后
  # load_and_authorize_resource
  skip_authorize_resource :only => [:ztree, :valid_dep_name, :search_bank]

  def index
  end

  def move
    ztree_move(Department)
  end

  def ztree
    nodes = @is_hide_dep.subtree.where.not(status: 404).order("sort")
    json = nodes.map{|n|%Q|{"id":#{n.id}, "pId":#{n.pid}, "name":"#{n.name}", "icon":"#{n.show_rys_icon}"}|}
    render :json => "[#{json.join(", ")}]"
    # ztree_nodes_json(Department, @is_hide_dep)
  end

  def new
    dep = Department.new
    dep.parent_id = params[:pid] unless params[:pid].blank?
    @myform = SingleForm.new(dep.parent.get_xml(current_user), dep, { form_id: "department_form", action: kobe_departments_path, grid: 2 })
  end

  def create
    p_id = params[:departments][:parent_id].present? ? params[:departments][:parent_id] : Dictionary.dep_purchaser_id
    parent_dep = Department.find_by(id: p_id)
    dep = create_and_write_logs(Department, parent_dep.get_xml(current_user))
    if dep
      dep.update(status: 65) if dep.is_dep_purchaser?
      redirect_to kobe_departments_path(id: dep)
    else
      redirect_to root_path
    end
  end

  def update
    if update_and_write_logs(@dep, @dep.get_xml(current_user))
      redirect_to kobe_departments_path(id: @dep)
    else
      redirect_back_or
    end
  end

  def edit
    @myform = SingleForm.new(@dep.get_xml(current_user), @dep, { form_id: "department_form", action: kobe_department_path(@dep), method: "patch", grid: 2 })
  end

  def show
  end

  # 删除单位
  def delete
    render partial: '/shared/dialog/opt_liyou', locals: { form_id: 'delete_dep_form', action: kobe_department_path(@dep), method: 'delete' }
  end

  def destroy
    @dep.change_status_and_write_logs("删除", stateless_logs("删除",params[:opt_liyou],false))
    tips_get("删除单位成功。")
    redirect_to kobe_departments_path(id: @dep.parent_id)
  end

  # 冻结单位
  def freeze
    render partial: '/shared/dialog/opt_liyou', locals: { form_id: 'freeze_dep_form', action: update_freeze_kobe_department_path(@dep) }
  end

  def update_freeze
    @dep.change_status_and_write_logs("冻结", stateless_logs("冻结",params[:opt_liyou],false))
    tips_get("冻结单位成功。")
    redirect_to kobe_departments_path(id: @dep)
  end

  # 恢复单位
  def recover
    render partial: '/shared/dialog/opt_liyou', locals: { form_id: 'recover_dep_form', action: update_recover_kobe_department_path(@dep) }
  end

  def update_recover
    @dep.change_status_and_write_logs("恢复", stateless_logs("恢复",params[:opt_liyou],false))
    tips_get("恢复单位成功。")
    redirect_to kobe_departments_path(id: @dep)
  end

  # 分配人员账号
  def add_user
  end

  def update_add_user
    attributes = params.require(:user).permit(:login, :password, :password_confirmation)
    attributes[:department_id] = params[:id]
    user = User.new(attributes)
    user.is_personal = false if current_user.is_supplier?
    if user.save
      user.set_auto_menu
      write_logs(user,"分配人员账号",'账号创建成功')
      tips_get("账号创建成功。")
      redirect_to kobe_departments_path(id: params[:id],u_id: user.id)
    else
      flash_get(user.errors.full_messages)
      redirect_back_or
    end
  end

  # 修改资质证书
  def upload
    @myform = SingleForm.new(nil, @dep, { form_id: "edit_upload", button: false, upload_files: true, min_number_of_files: 2, action: update_upload_kobe_department_path(@dep), title: '附件' })
  end

  def update_upload
    tips_get("上传附件成功。")
    redirect_to kobe_departments_path(id: @dep)
  end

  # 维护开户银行
  def show_bank
  end

  def edit_bank
  end

  def update_bank
    attributes = params.require(:dep).permit(:bank_account, :bank, :bank_code)
    if @dep.update(attributes)
      write_logs(@dep,"维护开户银行","#{@dep.bank} [#{@dep.bank_account}]")
      tips_get("开户银行保存成功。")
      redirect_to kobe_departments_path(id: @dep)
    else
      flash_get("操作失败！#{@dep.errors.full_messages}")
      redirect_back_or
    end
  end

  # 搜索开户银行
  def search_bank
    @banks = Bank.where(["name like ?", "%#{params[:keyword].gsub(' ','%')}%"]).limit(20) if params[:keyword].present?
  end

  # 注册提交
  def commit
    @dep.change_status_and_write_logs("提交",stateless_logs("提交","注册完成，提交！", false),@dep.commit_params, false)
    @dep.reload.create_task_queue
    tips_get("提交成功，请等待审核。")
    redirect_to kobe_departments_path(id: @dep)
  end

  # 验证单位名称
  def valid_dep_name
    render :text => valid_remote(Department, ["name = ? and id <> ? and dep_type is false and status <> 404", params[:departments][:name], params[:obj_id]])
  end

  # 单位查询 供应商管理
  def search
    @q = Department.supplier.subtree.where(get_conditions("departments")).ransack(params[:q])
    @deps = @q.result.page params[:page] if params[:q][:name_or_old_name_cont].present?
  end

  # 审核单位
  def list
    @deps = audit_list(Department, params[:tq].to_i == Dictionary.tq_no)
    # arr = []
    # arr << ["departments.status = ? ", 2]
    # arr << ["(task_queues.user_id = ? or task_queues.menu_id in (#{@menu_ids.join(",") }) )", current_user.id]
    # arr << ["task_queues.dep_id = ?", current_user.real_department.id]
    # cdt = get_conditions("departments", arr)
    # @q =  Department.joins(:task_queues).where(cdt).ransack(params[:q])
    # @deps = @q.result(distinct: true).page params[:page]
  end

  def audit
  end

  def update_audit
    save_audit(@dep)
    # 给刚注册的审核通过的入围供应商加站内消息
    if Department.effective_status.include? @dep.reload.status
      # 给审核功过的单位用户授权
      @dep.users.map(&:set_auto_menu)
    end
    redirect_to list_kobe_departments_path(tq: Dictionary.tq_no)
  end

  private

    def get_dep
      @dep = current_user.department
      if can? :search, @dep
        @dep = Department.find_by(id: params[:id]) if params[:id].present?
      else
        @dep = current_user.department.subtree.find_by(id: params[:id]) if current_user.is_admin && params[:id].present?
      end
      unless action_name == "ztree"
        cannot_do_tips unless @dep.present? && @dep.cando(action_name, current_user)
        audit_tips  if ['audit', 'update_audit'].include?(action_name) && !can_audit?(@dep,@menu_ids)
      end
      @is_hide_dep = (can?(:search, @dep) || current_user.is_admin) ? (@dep.is_dep_supplier? ? @dep.real_dep : current_user.real_department) : @dep
    end

    # 获取审核的menu_ids
    def get_audit_menu_ids
      @menu_ids = Menu.get_menu_ids("Department|list")
    end

end
