# -*- encoding : utf-8 -*-
class ProductsUpload < ActiveRecord::Base
  belongs_to :master, class_name: "Product", foreign_key: "master_id"

  has_attached_file :upload, :styles => {thumbnail: "100x75", md: "250x500", lg: "1280x1024"}
  validates_attachment_content_type :upload, :content_type => /\Aimage\/.*\Z/, :message => "只能上传图片文件"
  before_post_process :allow_only_images

  include Rails.application.routes.url_helpers
  include UploadFiles

  # 上传附件的提示 -- 需要跟下面的JS设置匹配
  def self.tips
    '<ol>
      <li>仅支持jpg、jpeg、png、gif等格式的图片文件；</li>
      <li>单个文件大小不能超过10M；</li>
    </ol>'
  end

  # 上传附件的JS设置 -- 需要跟上面的Tips匹配；注意：必须用单引号，避免正则表达式转义
  def self.jquery_setting(action_name="new")
    if action_name == "batch_new"
      '{
        autoUpload: true,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        maxNumberOfFiles: 200,
        maxFileSize: 10240000
      }'
    else
      '{
        autoUpload: true,
        acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        maxNumberOfFiles: 1,
        maxFileSize: 10240000
      }'
    end
  end
end
