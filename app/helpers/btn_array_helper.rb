# -*- encoding : utf-8 -*-
module BtnArrayHelper

  def users_btn(obj)
    arr = []
    dialog = "#opt_dialog"
    # 详细
    if obj.cando("show", current_user)
      title = obj.class.icon_action("详细")
      arr << [title, dialog, "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{title}", '#{kobe_user_path(obj)}', '#{dialog}') }]
    end

    # 修改
    if obj.cando("edit", current_user)
      arr << [obj.class.icon_action("修改"), "javascript:void(0)", onClick: "show_content('#{edit_kobe_user_path(obj)}','#show_ztree_content #ztree_content')"]
    end
    # 重置密码
    if obj.cando("reset_password", current_user)
      title = obj.class.icon_action("重置密码")
      arr << [title, dialog, "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{title}", '#{reset_password_kobe_user_path(obj)}', '#{dialog}') }]
    end
    # 冻结
    if obj.cando("freeze", current_user)
      title = obj.class.icon_action("冻结")
      arr << [title, dialog, "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{title}", '#{freeze_kobe_user_path(obj)}', '#{dialog}') }]
    end
    # 恢复
    if obj.cando("recover", current_user)
      title = obj.class.icon_action("恢复")
      arr << [title, dialog, "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{title}", '#{recover_kobe_user_path(obj)}', '#{dialog}') }]
    end
    # 模拟登录
    arr << [obj.class.icon_action("模拟登录"), "#{simulate_login_kobe_user_path(obj)}", method: "post", data: { confirm: "确定以该用户身份模拟登录吗?" }] if obj.cando("simulate_login", current_user)
    return arr
  end


  def departments_btn(obj,only_audit=false)
    show_div = '#show_ztree_content #ztree_content'
    dialog = "#opt_dialog"
    arr = []
    # 查看单位信息
    arr << [obj.class.icon_action("详细"), "javascript:void(0)", onClick: "show_content('#{kobe_department_path(obj)}', '#{show_div}')"] if can?(:read, obj) && obj.cando("show", current_user)
    # 提交
    arr << [obj.class.icon_action("提交"), "#{commit_kobe_department_path(obj)}", method: "post", data: { confirm: "提交后不允许再修改，确定提交吗?" }] if can?(:commit, obj) && obj.cando("commit", current_user)
    # 修改单位信息
    arr << [obj.class.icon_action("修改"), "javascript:void(0)", onClick: "show_content('#{edit_kobe_department_path(obj)}','#{show_div}')"] if can?(:edit, obj) && obj.cando("edit", current_user)
    # 修改资质证书
    arr << [obj.class.icon_action("上传附件"), "javascript:void(0)", onClick: "show_content('#{upload_kobe_department_path(obj)}','#{show_div}','edit_upload_fileupload')"] if can?(:upload, obj) && obj.cando("upload", current_user)
    # 维护开户银行
    arr << [obj.class.icon_action("维护开户银行"), "javascript:void(0)", onClick: "show_content('#{show_bank_kobe_department_path(obj)}','#{show_div}')"] if can?(:bank, obj) && obj.cando("show_bank", current_user)
    # 增加下属单位
    arr << [obj.class.icon_action("增加下属单位"), "javascript:void(0)", onClick: "show_content('#{new_kobe_department_path(pid: obj.id)}','#{show_div}')"] if can?(:create, obj) && obj.cando("new", current_user)
    # 分配人员账号
    title = obj.class.icon_action("增加人员")
    arr << [title, dialog, "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{title}", '#{add_user_kobe_department_path(obj)}', '#{dialog}') }] if can?(:add_user, obj) && obj.cando("add_user", current_user)
    # 删除
    arr << [obj.class.icon_action("删除"), dialog, "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{obj.class.icon_action('删除')}",'#{delete_kobe_department_path(obj)}', '#{dialog}') }] if can?(:update_destroy, obj) && obj.cando("delete", current_user)
    # 审核
    audit_opt = [obj.class.icon_action("审核"), "#{audit_kobe_department_path(obj)}"] if can?(:audit, obj) && obj.cando("audit", current_user)
    return [audit_opt] if audit_opt.present? && only_audit
    return arr
  end


  def products_btn(obj)
    arr = []
    # 查看详细
    arr << [obj.class.icon_action("详细"), kobe_product_path(obj), target: "_blank"]  if obj.cando("show", current_user)
    # 修改
    arr << [obj.class.icon_action("修改"), edit_kobe_product_path(obj)] if obj.cando("edit", current_user)
    # 下架
    arr << [obj.class.icon_action("下架"), "#{update_freeze_kobe_product_path(obj)}", method: "post", data: { confirm: "下架的作品在前台不显示，确定下架吗?" }] if obj.cando("update_freeze", current_user)
    # arr << [obj.class.icon_action("下架"), "#opt_dialog", "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{obj.class.icon_action('下架')}",'#{freeze_kobe_product_path(obj)}', "#opt_dialog") }] if obj.cando("freeze", current_user)
    # 上架
    arr << [obj.class.icon_action("上架"), "#{update_recover_kobe_product_path(obj)}", method: "post", data: { confirm: "上架的作品将在前台显示，确定上架吗?" }] if obj.cando("update_recover", current_user)
    # arr << [obj.class.icon_action("恢复"), "#opt_dialog", "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{obj.class.icon_action('恢复')}",'#{recover_kobe_product_path(obj)}', "#opt_dialog") }] if obj.cando("recover", current_user)
    # 删除
    arr << [obj.class.icon_action("删除"), "#{kobe_product_path(obj)}", method: "delete", data: { confirm: "删除后不可恢复，确定删除吗?" }] if obj.cando("destroy", current_user)
    # arr << [obj.class.icon_action("删除"), "#opt_dialog", "data-toggle" => "modal", onClick: %Q{ modal_dialog_show("#{obj.class.icon_action('删除')}",'#{delete_kobe_product_path(obj)}', "#opt_dialog") }] if obj.cando("delete", current_user)
    return arr
  end

end
