# -*- encoding : utf-8 -*-
class ErrorsController < ApplicationController

  # layout false

  def index
  	@no = params["no"] || "404"
  	@messages = transfer_code(@no)
  	# render :file => 'public/404.html' and return
  	# render :file => "#{Rails.root}/public/#{error_code}.html"
  end

  private

  def transfer_code(no)
  	ers = {
  		"404" => "页面不存在或者已过期",
  		"707" => %{
        <div class='content'>当前URL：#{request.referer} </div>
        您的浏览器版本太低，建议升级到IE 10以上版本，或者复制以上URL地址，使用火狐、谷歌、Safari等主流浏览器访问。<br>
        <div class='content'>
          <a href='http://www.firefox.com.cn' target='_blank'>火狐浏览器下载</a>&nbsp;&nbsp;
          <a href='http://www.google.cn/intl/zh-CN/chrome/browser/' target='_blank'>谷歌浏览器下载</a>&nbsp;&nbsp;
          <a href='http://www.apple.com/cn/safari/' target='_blank'>Safari浏览器下载</a>&nbsp;&nbsp;
        </div>
      },
      "334" => %{
        您输入的信息与实际不符，详情请联系服务热线：<br>
        办公物资：#{Dictionary.service_bg_tel}。<br>
        粮机物资：#{Dictionary.service_lj_tel}。<br>
        技术支持：#{Dictionary.technical_support}。<br><br>
      }
  	}
  	return ers[no]
  end
end
