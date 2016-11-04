# -*- encoding : utf-8 -*-
module JamesHelper

  # 面包屑
  def breadcrumbs_li(ha)
    str = ""
    ha.each do |k, v|
      if v == "active"
        str << "<li class='active'>#{k}</li>"
      else
        str << "<li> #{link_to k, v}</li>"
      end
    end
    str.html_safe
  end

  # 详细页面 根据XML取作品信息
  def get_details_params(product)
    if product.category.present?
      xml = product.category.params_xml
      str = ""
      Nokogiri::XML(xml).xpath("/root/node[not(@data_type='textarea')]").each do |node|
        next unless node.attributes.has_key? "column"
        str << "<li><strong>#{node.attributes["name"].to_str}:</strong> #{eval("product.#{node.attributes["column"].to_str}")}</li>"
      end
      str.html_safe
    end
  end

  # 显示作品
  def show_product(product)
    cdt = [1,2].include? product.category_id
    details = %Q{
      <li>#{ link_to '<i class="rounded-x fa fa-link"></i>'.html_safe, details_path(product.id) }</li>
    }
    tmp = %Q{
      <div class="cbp-title-dark">
        <div class="cbp-l-grid-agency-title">#{ product.title }</div>
        <div class="cbp-l-grid-agency-desc">#{ product.pcode }</div>
      </div>
    }
    %Q{
      <div class="cbp-item">
        <div class="cbp-caption margin-bottom-20">
          <div class="cbp-caption-defaultWrap">
            #{image_tag product.picture.upload.url(:md)}
          </div>
          <div class="cbp-caption-activeWrap">
            <div class="cbp-l-caption-alignCenter">
              <div class="cbp-l-caption-body">
                <ul class="link-captions no-bottom-space">
                  #{details if cdt}
                  <li>#{ link_to '<i class="rounded-x fa fa-search"></i>'.html_safe, product.picture.upload.url(:lg), class: "cbp-lightbox", "data-title" => product.summary }</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
        #{tmp if cdt}
      </div>
    }.html_safe
  end

end
