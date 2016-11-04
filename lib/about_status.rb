# -*- encoding : utf-8 -*-
module AboutStatus

  include AboutRuleStep

  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      scope :status_not_in, lambda { |status| where(["status not in (?) ", status]) }
    end
  end

  # 拓展类方法
  module ClassMethods
    # 无效的完结状态
    def finish_status
      (Dictionary.all_status_array.select{ |e| (e[1] % 7 == 5) } & self.status_array).map{ |e| e[1] }
    end

    # 审核状态
    def audit_status
      (Dictionary.all_status_array.select{ |e| (e[1] % 7 == 1) } & self.status_array).map{ |e| e[1] }
    end

    # 有效的状态
    def effective_status
      (Dictionary.all_status_array.select{ |e| (e[1] % 7 == 2) } & self.status_array).map{ |e| e[1] }
    end

    # 自动生效的有效状态
    def auto_effective_status
      (Dictionary.all_status_array.select{ |e| [16, 72, 51, 65, 2].include? e[1] } & self.status_array).map{ |e| e[1] }
    end

    # 可以修改的状态 包括有效状态
    def edit_status
      return only_edit_status | edit_and_effective_status
    end

    # 可以修改的状态 不包括有效状态下也可以修改
    def only_edit_status
      (Dictionary.all_status_array.select{ |e| (e[1] % 7 == 0) } & self.status_array).map{ |e| e[1] }
    end

    # 有效状态可以修改
    def edit_and_effective_status
      (Dictionary.all_status_array.select{ |e| [51, 65].include? e[1] } & self.status_array).map{ |e| e[1] }
    end

    # 等待买方操作的状态 可以修改预算
    def buyer_edit_status
      (Dictionary.all_status_array.select{ |e| (e[1] % 7 == 4) } & self.status_array).map{ |e| e[1] }
    end

    # 卖方操作的状态
    def seller_edit_status
      (Dictionary.all_status_array.select{ |e| (e[1] % 7 == 3) } & self.status_array).map{ |e| e[1] }
    end

    # 列表中的状态筛选, 默认404不显示
    def status_filter(arr = [])
      # 列表中不允许出现的
      arr = [404] if arr.blank?
      limited = arr
      arr = self.status_array.delete_if{|a|limited.include?(a[1])}.map{|a|[a[0],a[1]]}
    end

    # 在application中的所有状态中，获取每个model中所需要的状态
    def get_status_array(arr=[])
      Dictionary.all_status_array.select{ |e| arr.include? e.first }
    end

    # 获取状态的属性数组 i表示状态数组的维度，0按中文查找，1按数字查找
    def get_status_attributes(status, i = 0)
      arr = self.status_array
      return arr.find{|n|n[i] == status}
    end

    # 批量改变状态并写入日志 默认状态改变才更新 状态不变不更新
    def batch_change_status_and_write_logs(id_array,status,stateless_logs,update_params=[],status_change=true)
      status = self.get_status_attributes(status)[1] unless status.is_a?(Integer)
      update_params << "status = #{status}"
      update_params << "logs = replace(IFNULL(logs,'<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n</root>'),'</root>','  #{stateless_logs.gsub('$STATUS$',status.to_s)}\n</root>')"
      # self.where(id: id_array).where.not(status: [404, status]).update_all("status = #{status}, logs = replace(IFNULL(logs,'<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n</root>'),'</root>','  #{stateless_logs.gsub('$STATUS$',status.to_s)}\n</root>')")
      if status_change
        self.where(id: id_array).where.not(status: [404, status]).update_all(update_params.join(", "))
      else # 用于审核转向下一人时 状态不变 但要记录日志
        self.where(id: id_array).where.not(status: [404]).update_all(update_params.join(", "))
      end
    end

    # 判断是否树形结构
    def is_ancestry?
      self.attribute_names.include?("ancestry")
    end

    # 带图标的动作
    def icon_action(action,left=true)
      key = Dictionary.icons.keys.find{|key|action.index(key)}
      icon = key ? Dictionary.icons[key] : Dictionary.icons["其他"]
      return left ? "<i class='fa #{icon}'></i> #{action}" : "#{action} <i class='fa #{icon}'></i>"
    end

  end

  # 状态标签
  def status_badge(status=self.status)
    # arr = self.class.get_status_attributes(status,1)
    arr = Dictionary.all_status_array.find{ |e| e[1] == status.to_i }
    if arr.blank?
      str = "<span class='label rounded-2x label-dark'>未知</span>"
    else
      str = "<span class='label rounded-2x label-#{arr[2]}'>#{arr[0]}</span>"
    end
    return str.html_safe
  end

  # 状态进度条
  def status_bar(status=self.status)
    # arr = self.class.get_status_attributes(status,1)
    arr = Dictionary.all_status_array.find{ |e| e[1] == status.to_i }
    return "" if arr.blank?
    title = self.class.edit_status.include?(self.status) ? %Q{<span data-original-title="请提交订单" data-toggle="tooltip" class="tooltips">#{arr[0]}</span>} : arr[0]
    return %Q|
    <span class='heading-xs'>#{title} <span class='pull-right'>#{arr[3]}%</span></span>
    <div class='progress progress-u progress-xs'>
    <div style='width: #{arr[3]}%' aria-valuemax='100' aria-valuemin='0' aria-valuenow='#{arr[3]}' role='progressbar' class='progress-bar progress-bar-#{arr[2]}'></div>
    </div>|.html_safe
  end

  # 更新状态并写入日志 默认连同孩子节点一起更新 update_subtree
  def change_status_and_write_logs(opt,stateless_logs,update_params=[],update_subtree=true)
    # status = self.class.get_status_attributes(status)[1] unless status.is_a?(Integer)
    # self.update_columns("status" => status, "logs" => logs) unless status == self.status
    status = self.get_change_status(opt)
    if self.class.is_ancestry? && self.has_children? && update_subtree
    # id_array = self.class.self_and_descendants(self.id).status_not_in([404, status]).map(&:id)
    id_array = self.subtree.status_not_in([404, status]).map(&:id)
    else
      id_array = self.id
    end
    self.class.batch_change_status_and_write_logs(id_array,status,stateless_logs,update_params)
  end

  # 根据不同操作 获取需改变的状态 返回数字格式的状态
  def get_change_status(opt)
    if self.class.attribute_method?("change_status_hash") && self.change_status_hash[opt].present?
      status = self.change_status_hash[opt][self.status] # 获取更新后的状态
      return status.present? ? status : self.status
    else
      return opt.is_a?(Integer) ? opt : self.class.get_status_attributes(opt)[1]
    end
  end

  # 根据状态变更判断是否有某个操作
  def can_opt?(opt)
    if self.class.attribute_method? "change_status_hash"
      return false if self.change_status_hash[opt].blank?
      status = self.change_status_hash[opt][self.status]
      # ["暂存", 0, "orange", 50] 获得 "暂存"
      # 			cn_status = self.class.get_status_attributes(self.status, 1)[0] # 当前状态转成中文
      # 			status = self.change_status_hash[opt][cn_status] # 获取更新后的状态
      return status.present?
    else
      return false
    end
  end

  # 根据不同操作 改变状态
  def change_status_hash
    # 如果是订单表 并且已经填写发票号 提交和审核通过的状态变成93
    # tmp = self.class == Order && self.invoice_number.present? && Dictionary.yw_type.include?(self.rule.try(:yw_type))
    ha = {
      "删除" => { 65 => 404 },

      "下架" => { 65 => 26 },
      "冻结" => { 65 => 12 },
      "停止" => { 65 => 54 },
      "恢复" => { 12 => 65, 26 => 65, 54 => 65 },

      "回复" => { 58 => 75 }
    }

    # 修改状态都可以删除
    self.class.edit_status.each{ |s| ha["删除"][s] = 404 }

    # 提交后自动生效
    # auto_status = tmp ? 93 : self.class.auto_effective_status.first
    auto_status = self.class.auto_effective_status.first
    ha["提交"] = { 0 => auto_status, 7 => auto_status, 14 => 16 } if auto_status.present?

    if self.class.attribute_method? "rule"
      cs = self.get_current_step
      rs = cs.is_a?(Hash) ? cs : self.find_step_by_rule
      if rs.present?
        start_status = rs["start_status"].to_i
        return_status = rs["return_status"].to_i
        ns = self.get_next_step
        finish_status = ns.is_a?(Hash) ? ns["start_status"].to_i : rs["finish_status"].to_i
        # 如果当前状态是修改状态，提交后变成开始某流程步骤的状态 start_status
        ha["提交"] = { self.status => start_status } if self.class.only_edit_status.include? self.status
        # 通过本步骤 状态转向 下一步的开始状态 如果没有下一步则是本部的结束状态
        # finish_status = tmp ? 93 : finish_status
        ha["通过"] = { start_status => finish_status, 10 =>  finish_status, 42 => finish_status }
        # 不通过 状态转向 本步的退回状态
        ha["不通过"] = { start_status => return_status, 10 =>  return_status, 42 => return_status }

        # 有效状态都可以作废
        ha["作废"] = Hash.new
        self.class.effective_status.each{ |s| ha["作废"][s] = start_status }
      end
    end
    return ha
  end

  # 操作理由xml
  def opt_xml
    %Q{
      <?xml version='1.0' encoding='UTF-8'?>
      <root>
        <node name='操作理由' column='opt_liyou' class='required' placeholder='请输入操作理由...'/>
      </root>
    }
  end

  # 审核的下一步操作 确认并转向上级单位审核、确认并结束审核流程
  def go_to_audit_next(audit_yijian, logs, audit_next_user_id='')
    cs = self.get_current_step
    if cs.is_a?(Hash)
      ns = self.get_next_step
      rule_step = ns.is_a?(Hash) ? ns["name"] : ns
      next_status = self.get_change_status(audit_yijian)
      if self.status == next_status
        # 状态相同的 例如分公司转总公司的
        self.class.batch_change_status_and_write_logs(self.id, self.status, logs, ["rule_step = '#{rule_step}'"], false)
      else
        # 状态根据下一步的start_status 或当前步骤的finish_status 转变
        self.change_status_and_write_logs(audit_yijian, logs, ["rule_step = '#{rule_step}'"], false)
      end
    end
    # 插入待办事项
    self.reload.create_task_queue
  end

  # 审核 退回发起人 状态改变 rule_step改变
  def go_to_audit_return(audit_yijian, logs, audit_next_user_id='')
    self.change_status_and_write_logs(audit_yijian, logs, ["rule_step = null"], false)
    # 删除待办事项
    self.reload.delete_task_queue
    # 发送站内消息

  end

  # 审核 转向下一人 状态不变 rule_step不变
  def go_to_audit_turn(audit_yijian, logs, audit_next_user_id='')
    self.class.batch_change_status_and_write_logs(self.id, self.status, logs, [], false)
    # 插入待办事项
    self.reload.create_task_queue(audit_next_user_id.split("_")[1])
  end

  # 保存日志 other_params[:no_logs]: 不写日志
  def save_logs(user, action, remark, other_params={})
    status = other_params.has_key?(:status) ? other_params[:status] : self.status
    self.status = status

    return if (!self.status_changed? && self.class == Pay) || (other_params.has_key?(:no_logs) && other_params[:no_logs])
    xml = self.logs
    user = user || User.find_by(login: 'zcl001')
    if xml.present?
      doc = Nokogiri::XML(xml)
    else
      doc = Nokogiri::XML::Document.new()
      doc.encoding = "UTF-8"
      doc << "<root>"
    end
    node = doc.root.add_child("<node>").first
    node["操作时间"] = Time.now.to_s(:db)
    node["操作人ID"] = user.id.to_s
    node["操作人姓名"] = user.name.to_s
    node["操作人单位"] = user.department.nil? ? "暂无" : user.department.name.to_s
    node["操作内容"] = action
    node["当前状态"] = status
    node["备注"] = remark
    other_params[:logs] = doc.to_s
    other_params.delete_if{|k,v| k == :no_logs}
    self.update(other_params)
  end

end
