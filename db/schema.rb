# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20161029077744) do

  create_table "agents", force: true do |t|
    t.integer  "item_id",                          default: 0, null: false, comment: "项目ID"
    t.integer  "department_id",                    default: 0, null: false, comment: "单位ID"
    t.integer  "agent_id",                         default: 0, null: false, comment: "代理商单位ID"
    t.string   "name",                                         null: false, comment: "代理商名称"
    t.text     "area_id",                                                   comment: "地区id"
    t.integer  "status",        limit: 2,          default: 0, null: false, comment: "状态"
    t.text     "details",                                                   comment: "明细"
    t.integer  "user_id",                          default: 0, null: false, comment: "用户ID"
    t.text     "logs",          limit: 2147483647,                          comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "category_id"
  end

  add_index "agents", ["agent_id"], name: "index_agents_on_agent_id", using: :btree
  add_index "agents", ["department_id", "item_id"], name: "index_agents_on_department_id_and_item_id", using: :btree
  add_index "agents", ["department_id"], name: "index_agents_on_department_id", using: :btree
  add_index "agents", ["item_id"], name: "index_agents_on_item_id", using: :btree
  add_index "agents", ["user_id"], name: "index_agents_on_user_id", using: :btree

  create_table "areas", force: true do |t|
    t.string   "name",           comment: "单位名称"
    t.string   "ancestry",       comment: "祖先节点"
    t.integer  "ancestry_depth", comment: "层级"
    t.string   "code",           comment: "编号"
    t.integer  "sort",           comment: "排序"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pcc_name"
    t.string   "pcc_ids"
  end

  create_table "article_catalogs", force: true do |t|
    t.string   "name",                              null: false
    t.integer  "status",         limit: 2
    t.text     "details"
    t.text     "logs",           limit: 2147483647
    t.float    "sort",           limit: 24
    t.string   "ancestry"
    t.integer  "ancestry_depth"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_catalogs_articles", id: false, force: true do |t|
    t.integer "article_id"
    t.integer "article_catalog_id"
  end

  add_index "article_catalogs_articles", ["article_catalog_id"], name: "index_article_catalogs_articles_on_article_catalog_id", using: :btree
  add_index "article_catalogs_articles", ["article_id", "article_catalog_id"], name: "my_index", unique: true, using: :btree
  add_index "article_catalogs_articles", ["article_id"], name: "index_article_catalogs_articles_on_article_id", using: :btree

  create_table "article_contents", force: true do |t|
    t.integer  "article_id", null: false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "article_uploads", ["master_id"], name: "index_article_uploads_on_master_id", using: :btree

  create_table "articles", force: true do |t|
    t.string   "title",                                                         comment: "标题"
    t.integer  "user_id",                                          null: false, comment: "发布者ID"
    t.datetime "publish_time",                                                  comment: "发布时间"
    t.string   "tags",                                                          comment: "标签"
    t.integer  "new_days",                             default: 3, null: false, comment: "几天内显示new标签"
    t.integer  "top_type",                             default: 0, null: false, comment: "置顶类别"
    t.integer  "access_permission",                    default: 0, null: false, comment: "访问权限"
    t.integer  "status",                               default: 0, null: false, comment: "状态"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.text     "logs",              limit: 2147483647
    t.text     "content",           limit: 2147483647
    t.integer  "hits",                                 default: 0
    t.integer  "rule_id",                                                       comment: "流程ID"
    t.string   "rule_step",                                                     comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.text     "catalogids"
    t.text     "details"
    t.integer  "department_id"
  end

  add_index "articles", ["rule_id"], name: "index_articles_on_rule_id", using: :btree
  add_index "articles", ["rule_step"], name: "index_articles_on_rule_step", using: :btree
  add_index "articles", ["status"], name: "index_articles_on_status", using: :btree
  add_index "articles", ["tags"], name: "index_articles_on_tags", using: :btree
  add_index "articles", ["title"], name: "index_articles_on_title", using: :btree
  add_index "articles", ["top_type"], name: "index_articles_on_top_type", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "articles_categories", force: true do |t|
    t.integer "article_id",  null: false
    t.integer "category_id", null: false
  end

  add_index "articles_categories", ["article_id", "category_id"], name: "index_articles_categories_on_article_id_and_category_id", using: :btree

  create_table "asset_evaluation_bids", force: true do |t|
    t.integer  "asset_evaluation_id",                                             default: 0,     null: false, comment: "项目ID"
    t.boolean  "is_bid",                                                          default: false, null: false, comment: "是否中标"
    t.datetime "response_at",                                                                                  comment: "响应时间"
    t.datetime "bid_at",                                                                                       comment: "报价时间"
    t.integer  "department_id"
    t.string   "dep_name",                                                                                     comment: "单位名称"
    t.string   "dep_code",                                                                                     comment: "单位real_ancestry"
    t.string   "dep_man",                                                                                      comment: "联系人"
    t.string   "dep_tel",                                                                                      comment: "联系人电话"
    t.string   "dep_mobile",                                                                                   comment: "联系人手机"
    t.string   "dep_addr",                                                                                     comment: "通讯地址"
    t.decimal  "total",                                  precision: 13, scale: 2, default: 0.0,   null: false, comment: "报价（元）"
    t.text     "summary",                                                                                      comment: "服务条款"
    t.integer  "user_id",                                                         default: 0,     null: false, comment: "用户ID"
    t.text     "details",                                                                                      comment: "明细"
    t.text     "logs",                limit: 2147483647,                                                       comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asset_evaluation_bids", ["asset_evaluation_id", "department_id"], name: "ae_id_dep_id", unique: true, using: :btree
  add_index "asset_evaluation_bids", ["asset_evaluation_id"], name: "index_asset_evaluation_bids_on_asset_evaluation_id", using: :btree

  create_table "asset_evaluation_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "yw_type",                         comment: "业务类型"
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asset_evaluation_uploads", ["master_id", "yw_type"], name: "index_asset_evaluation_uploads_on_master_id_and_yw_type", using: :btree

  create_table "asset_evaluations", force: true do |t|
    t.integer  "yw_type",                                                                                  comment: "标的性质"
    t.integer  "rule_id",                                                                                  comment: "流程ID"
    t.string   "rule_step",                                                                                comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.string   "name",                                                                        null: false, comment: "资产评估项目名称"
    t.string   "sn",                                                                                       comment: "资产评估项目编号"
    t.integer  "department_id"
    t.datetime "publish_at",                                                                               comment: "发布时间"
    t.datetime "response_end_time",                                                                        comment: "响应截止时间"
    t.datetime "bid_end_time",                                                                             comment: "报价截止时间"
    t.decimal  "book_value",                           precision: 13, scale: 2, default: 0.0, null: false, comment: "账面净值（元）"
    t.string   "asset_name",                                                                               comment: "评估对象"
    t.string   "dep_name",                                                                                 comment: "产权持有单位/接受非国有资产的企业"
    t.string   "manage_level",                                                                             comment: "企业管理级次"
    t.text     "economic_type",                                                                            comment: "经济行为类型"
    t.string   "dep_code",                                                                                 comment: "采购单位real_ancestry"
    t.string   "dep_man",                                                                                  comment: "联系人"
    t.string   "dep_tel",                                                                                  comment: "联系人电话"
    t.string   "dep_mobile",                                                                               comment: "联系人手机"
    t.string   "dep_addr",                                                                                 comment: "通讯地址"
    t.text     "asset_info",        limit: 2147483647,                                                     comment: "资产内容"
    t.text     "summary",           limit: 2147483647,                                                     comment: "其他说明"
    t.decimal  "change_price",                         precision: 13, scale: 2, default: 0.0, null: false, comment: "变更价格"
    t.text     "change_reason",                                                                            comment: "变更情况说明"
    t.text     "reason",                                                                                   comment: "选择中标人理由"
    t.integer  "user_id",                                                       default: 0,   null: false, comment: "用户ID"
    t.integer  "status",            limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                                  comment: "明细"
    t.text     "logs",              limit: 2147483647,                                                     comment: "日志"
    t.decimal  "total",                                precision: 13, scale: 2, default: 0.0, null: false, comment: "评价得分"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asset_evaluations", ["sn"], name: "index_asset_evaluations_on_sn", unique: true, using: :btree

  create_table "asset_project_items", force: true do |t|
    t.integer  "asset_project_id",                          default: 0,   null: false, comment: "项目ID"
    t.integer  "fixed_asset_id",                                                       comment: "品目"
    t.string   "asset_name",                                                           comment: "车类别"
    t.decimal  "total",            precision: 13, scale: 2, default: 0.0, null: false, comment: "总金额"
    t.text     "details",                                                              comment: "明细"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asset_project_items", ["asset_project_id"], name: "index_asset_project_items_on_asset_project_id", using: :btree
  add_index "asset_project_items", ["fixed_asset_id"], name: "index_asset_project_items_on_fixed_asset_id", using: :btree

  create_table "asset_projects", force: true do |t|
    t.integer  "rule_id",                                                                              comment: "流程ID"
    t.string   "rule_step",                                                                            comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.string   "name",                                                                    null: false, comment: "名称"
    t.string   "sn",                                                                                   comment: "凭证编号（验收单号）"
    t.integer  "department_id"
    t.string   "dep_name",                                                                             comment: "采购单位名称"
    t.string   "dep_code",                                                                             comment: "采购单位real_ancestry"
    t.string   "dep_man",                                                                              comment: "采购单位联系人"
    t.decimal  "total",                            precision: 13, scale: 2, default: 0.0, null: false, comment: "总金额"
    t.date     "deliver_at",                                                                           comment: "报销时间"
    t.text     "summary",                                                                              comment: "基本情况（备注）"
    t.integer  "user_id",                                                   default: 0,   null: false, comment: "用户ID"
    t.integer  "status",        limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                              comment: "明细"
    t.text     "logs",          limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banks", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bargain_bid_products", force: true do |t|
    t.integer "bargain_bid_id",                              default: 0,   null: false, comment: "协议议价报价ID"
    t.integer "bargain_product_id",                          default: 0,   null: false, comment: "协议议价产品ID"
    t.integer "product_id"
    t.text    "details"
    t.decimal "price",              precision: 20, scale: 2, default: 0.0, null: false, comment: "单价"
    t.decimal "total",              precision: 20, scale: 2, default: 0.0, null: false, comment: "总价"
  end

  add_index "bargain_bid_products", ["bargain_bid_id"], name: "index_bargain_bid_products_on_bargain_bid_id", using: :btree
  add_index "bargain_bid_products", ["bargain_product_id", "product_id"], name: "index_bargain_bid_products_on_bargain_product_id_and_product_id", unique: true, using: :btree
  add_index "bargain_bid_products", ["bargain_product_id"], name: "index_bargain_bid_products_on_bargain_product_id", using: :btree
  add_index "bargain_bid_products", ["product_id"], name: "index_bargain_bid_products_on_product_id", using: :btree

  create_table "bargain_bids", force: true do |t|
    t.integer  "bargain_id",                                                 default: 0,     null: false, comment: "协议议价ID"
    t.integer  "department_id"
    t.string   "name",                                                                                    comment: "供应商单位"
    t.string   "dep_man",                                                                                 comment: "供应商联系人"
    t.string   "dep_tel",                                                                                 comment: "供应商联系人座机"
    t.string   "dep_mobile",                                                                              comment: "供应商联系人手机"
    t.string   "dep_addr",                                                                                comment: "供应商联系人地址"
    t.text     "details"
    t.integer  "user_id"
    t.boolean  "is_bid",                                                     default: false, null: false, comment: "是否中标"
    t.datetime "bid_time",                                                                                comment: "报价时间"
    t.decimal  "total",                             precision: 20, scale: 2, default: 0.0,   null: false, comment: "总金额"
    t.decimal  "deliver_fee",                       precision: 20, scale: 2,                              comment: "运费"
    t.decimal  "other_fee",                         precision: 20, scale: 2,                              comment: "其他费用"
    t.string   "other_fee_desc",                                                                          comment: "其他费用说明"
    t.text     "logs",           limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bargain_bids", ["bargain_id", "department_id"], name: "index_bargain_bids_on_bargain_id_and_department_id", unique: true, using: :btree
  add_index "bargain_bids", ["bargain_id"], name: "index_bargain_bids_on_bargain_id", using: :btree
  add_index "bargain_bids", ["department_id"], name: "index_bargain_bids_on_department_id", using: :btree

  create_table "bargain_products", force: true do |t|
    t.integer  "bargain_id",                          default: 0,   null: false, comment: "协议议价ID"
    t.decimal  "quantity",   precision: 13, scale: 3, default: 0.0, null: false, comment: "数量"
    t.string   "unit",                                                           comment: "计量单位"
    t.text     "details",                                                        comment: "明细"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bargain_products", ["bargain_id"], name: "index_bargain_products_on_bargain_id", using: :btree

  create_table "bargain_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bargain_uploads", ["master_id"], name: "index_bargain_uploads_on_master_id", using: :btree

  create_table "bargains", force: true do |t|
    t.integer  "item_id",                                                   default: 0,   null: false, comment: "项目ID"
    t.integer  "category_id",                                               default: 0,   null: false, comment: "品目ID"
    t.string   "category_code",                                             default: "0", null: false, comment: "品目编号"
    t.integer  "rule_id",                                                                              comment: "流程ID"
    t.string   "rule_step",                                                                            comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.string   "name",                                                                    null: false, comment: "名称"
    t.string   "sn",                                                                                   comment: "协议议价编号"
    t.integer  "department_id"
    t.string   "dep_name",                                                                             comment: "采购单位名称"
    t.string   "invoice_title",                                                                        comment: "发票抬头"
    t.string   "dep_code",                                                                             comment: "采购单位real_ancestry"
    t.string   "dep_man",                                                                              comment: "采购单位联系人"
    t.string   "dep_tel",                                                                              comment: "采购单位联系人座机"
    t.string   "dep_mobile",                                                                           comment: "采购单位联系人手机"
    t.string   "dep_addr",                                                                             comment: "单位地址"
    t.integer  "budget_id"
    t.decimal  "total",                            precision: 13, scale: 2,                            comment: "总预算金额"
    t.text     "summary",                                                                              comment: "基本情况（备注）"
    t.integer  "user_id",                                                   default: 0,   null: false, comment: "用户ID"
    t.integer  "status",        limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                              comment: "明细"
    t.text     "logs",          limit: 2147483647,                                                     comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bargains", ["budget_id"], name: "index_bargains_on_budget_id", using: :btree
  add_index "bargains", ["category_id"], name: "index_bargains_on_category_id", using: :btree
  add_index "bargains", ["dep_code"], name: "index_bargains_on_dep_code", using: :btree
  add_index "bargains", ["department_id"], name: "index_bargains_on_department_id", using: :btree
  add_index "bargains", ["item_id"], name: "index_bargains_on_item_id", using: :btree
  add_index "bargains", ["sn"], name: "index_bargains_on_sn", unique: true, using: :btree

  create_table "batch_audits", force: true do |t|
    t.integer  "obj_id",       default: 0,       null: false, comment: "实例ID"
    t.string   "class_name",   default: "Order", null: false, comment: "类名"
    t.string   "next",                                        comment: "下一步"
    t.string   "yijian",                                      comment: "审核意见"
    t.string   "liyou",                                       comment: "审核理由"
    t.string   "next_user_id",                                comment: "转向下一个审核人"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                     comment: "当前操作用户ID"
  end

  create_table "bid_item_bids", force: true do |t|
    t.integer "bid_project_id"
    t.integer "bid_item_id"
    t.string  "brand_name"
    t.string  "xh"
    t.integer "user_id"
    t.text    "details"
    t.integer "bid_project_bid_id"
    t.decimal "price",              precision: 20, scale: 2, default: 0.0, null: false, comment: "单价"
    t.decimal "total",              precision: 20, scale: 2, default: 0.0, null: false, comment: "总价"
    t.text    "req"
    t.text    "remark"
  end

  add_index "bid_item_bids", ["bid_item_id", "user_id"], name: "index_bid_item_bids_on_bid_item_id_and_user_id", unique: true, using: :btree
  add_index "bid_item_bids", ["bid_item_id"], name: "index_bid_item_bids_on_bid_item_id", using: :btree
  add_index "bid_item_bids", ["bid_project_bid_id"], name: "index_bid_item_bids_on_bid_project_bid_id", using: :btree
  add_index "bid_item_bids", ["bid_project_id"], name: "index_bid_item_bids_on_bid_project_id", using: :btree

  create_table "bid_items", force: true do |t|
    t.integer  "category_id",                                                                  comment: "品目ID"
    t.integer  "bid_project_id",                                                               comment: "竞价ID"
    t.string   "category_name"
    t.string   "brand_name",                                                                   comment: "参考品牌"
    t.string   "xh",                                                                           comment: "参考型号"
    t.decimal  "num",                      precision: 13, scale: 3, default: 0.0, null: false, comment: "数量"
    t.string   "unit",                                                                         comment: "计量单位"
    t.integer  "can_other",      limit: 2,                          default: 0,   null: false, comment: "是否允许投报其他型号的产品"
    t.text     "req",                                                                          comment: "技术指标和服务要求"
    t.text     "remark",                                                                       comment: "备注信息"
    t.text     "details"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bid_items", ["bid_project_id"], name: "index_bid_items_on_bid_project_id", using: :btree
  add_index "bid_items", ["category_id"], name: "index_bid_items_on_category_id", using: :btree

  create_table "bid_project_bid_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bid_project_bid_uploads", ["master_id"], name: "index_bid_project_bid_uploads_on_master_id", using: :btree

  create_table "bid_project_bids", force: true do |t|
    t.integer  "bid_project_id"
    t.string   "com_name",                                                             comment: "供应商单位"
    t.string   "username",                                                             comment: "供应商姓名"
    t.string   "tel"
    t.string   "mobile"
    t.text     "details"
    t.string   "add"
    t.integer  "user_id"
    t.decimal  "total",          precision: 20, scale: 2, default: 0.0,   null: false, comment: "总金额"
    t.text     "logs"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "bid_time"
    t.integer  "department_id"
    t.boolean  "is_bid",                                  default: false, null: false
  end

  add_index "bid_project_bids", ["bid_project_id", "user_id"], name: "index_bid_project_bids_on_bid_project_id_and_user_id", unique: true, using: :btree
  add_index "bid_project_bids", ["bid_project_id"], name: "index_bid_project_bids_on_bid_project_id", using: :btree
  add_index "bid_project_bids", ["user_id"], name: "index_bid_project_bids_on_user_id", using: :btree

  create_table "bid_project_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bid_project_uploads", ["master_id"], name: "index_bid_project_uploads_on_master_id", using: :btree

  create_table "bid_projects", force: true do |t|
    t.string   "buyer_dep_name",                                                                            comment: "采购单位"
    t.string   "invoice_title",                                                                             comment: "发票单位"
    t.string   "buyer_name",                                                                                comment: "采购人姓名"
    t.string   "buyer_phone",                                                                               comment: "采购人电话"
    t.string   "buyer_mobile",                                                                              comment: "采购人手机"
    t.string   "buyer_add",                                                                                 comment: "采购人地址"
    t.integer  "lod",                                                                                       comment: "明标或暗标"
    t.datetime "end_time",                                                                                  comment: "截止时间"
    t.decimal  "budget_money",                          precision: 20, scale: 2, default: 0.0, null: false
    t.text     "req",                                                                                       comment: "资质要求"
    t.text     "remark",                                                                                    comment: "备注信息"
    t.integer  "status",             limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "logs",               limit: 2147483647,                                                     comment: "日志"
    t.string   "name",                                                                                      comment: "名称"
    t.string   "code",                                                                                      comment: "编号"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id",                                                                             comment: "单位ID"
    t.string   "department_code",                                                                           comment: "单位CODE"
    t.integer  "bid_project_bid_id",                                                                        comment: "中标投标ID"
    t.text     "reason",                                                                                    comment: "理由"
    t.integer  "item_id",                                                                                   comment: "指定供应商的项目"
    t.integer  "rule_id"
    t.string   "rule_step"
    t.integer  "budget_id"
    t.text     "details"
  end

  add_index "bid_projects", ["bid_project_bid_id"], name: "index_bid_projects_on_bid_project_bid_id", using: :btree
  add_index "bid_projects", ["budget_id"], name: "index_bid_projects_on_budget_id", using: :btree
  add_index "bid_projects", ["item_id"], name: "index_bid_projects_on_item_id", using: :btree
  add_index "bid_projects", ["rule_id"], name: "index_bid_projects_on_rule_id", using: :btree
  add_index "bid_projects", ["status"], name: "index_bid_projects_on_status", using: :btree
  add_index "bid_projects", ["user_id"], name: "index_bid_projects_on_user_id", using: :btree

  create_table "budget_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budgets", force: true do |t|
    t.integer  "rule_id",                                                                              comment: "流程ID"
    t.string   "rule_step",                                                                            comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.integer  "department_id"
    t.string   "dep_code",                                                                             comment: "采购单位real_ancestry"
    t.string   "name",                                                                    null: false, comment: "名称"
    t.decimal  "total",                            precision: 13, scale: 2, default: 0.0, null: false
    t.text     "summary",                                                                              comment: "基本情况（备注）"
    t.integer  "user_id",                                                   default: 0,   null: false, comment: "用户ID"
    t.integer  "status",        limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                              comment: "明细"
    t.text     "logs",          limit: 2147483647,                                                     comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "budgets", ["department_id"], name: "index_budgets_on_department_id", using: :btree
  add_index "budgets", ["user_id"], name: "index_budgets_on_user_id", using: :btree

  create_table "catalogs", force: true do |t|
    t.string   "name",                                 null: false, comment: "名称"
    t.string   "ancestry",                                          comment: "祖先节点"
    t.integer  "ancestry_depth",                                    comment: "层级"
    t.string   "icon",                                              comment: "图标"
    t.integer  "status",         limit: 2, default: 0, null: false, comment: "状态"
    t.integer  "sort",                                              comment: "排序"
    t.text     "params",                                            comment: "参数"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "catalogs", ["name"], name: "index_catalogs_on_name", unique: true, using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",                                                 null: false, comment: "名称"
    t.string   "ancestry",                                                          comment: "祖先节点"
    t.integer  "ancestry_depth",                                                    comment: "层级"
    t.integer  "audit_type",                                                        comment: "审核部门 -1：分公司审核，0：分公司审完总公司审，1：总公司审核"
    t.integer  "status",         limit: 2,          default: 0,        null: false, comment: "状态"
    t.string   "ht_template",                       default: "common", null: false, comment: "合同模板"
    t.boolean  "show_mall",                         default: false,    null: false, comment: "显示在首页"
    t.integer  "yw_type",                           default: 0,        null: false
    t.integer  "sort",                                                              comment: "排序"
    t.text     "params_xml",                                                        comment: "参数"
    t.text     "details",                                                           comment: "明细"
    t.text     "logs",           limit: 2147483647,                                 comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["ancestry"], name: "index_categories_on_ancestry", using: :btree
  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "contract_templates", force: true do |t|
    t.string   "file_name",                                        null: false, comment: "文件名"
    t.string   "name",                                             null: false, comment: "模板名称"
    t.string   "url",                  default: "/kobe/orders/ht", null: false, comment: "模板文件URL"
    t.integer  "status",     limit: 2, default: 0,                 null: false, comment: "状态"
    t.text     "details",                                                       comment: "明细"
    t.text     "logs",                                                          comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coordinators", force: true do |t|
    t.integer  "item_id",                          default: 0, null: false, comment: "项目ID"
    t.integer  "department_id",                    default: 0, null: false, comment: "单位ID"
    t.string   "name",                                                      comment: "姓名"
    t.string   "tel",                                                       comment: "电话"
    t.string   "mobile",                                                    comment: "手机"
    t.string   "fax",                                                       comment: "传真"
    t.string   "email",                                                     comment: "Email"
    t.integer  "status",        limit: 2,          default: 0, null: false, comment: "状态"
    t.text     "summary",                                                   comment: "备注"
    t.text     "details",                                                   comment: "明细"
    t.integer  "user_id",                          default: 0, null: false, comment: "用户ID"
    t.text     "logs",          limit: 2147483647,                          comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "category_id"
  end

  add_index "coordinators", ["department_id", "item_id"], name: "index_coordinators_on_department_id_and_item_id", using: :btree
  add_index "coordinators", ["user_id"], name: "index_coordinators_on_user_id", using: :btree

  create_table "daily_categories", force: true do |t|
    t.string   "name",                                          null: false, comment: "名称"
    t.string   "ancestry",                                                   comment: "祖先节点"
    t.integer  "ancestry_depth",                                             comment: "层级"
    t.integer  "status",         limit: 2,          default: 0, null: false, comment: "状态"
    t.integer  "sort",                                                       comment: "排序"
    t.text     "details",                                                    comment: "明细"
    t.text     "logs",           limit: 2147483647,                          comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_cost_items", force: true do |t|
    t.integer  "daily_cost_id",                              default: 0,   null: false, comment: "订单ID"
    t.integer  "daily_category_id",                                                     comment: "品目"
    t.string   "category_code",                                            null: false, comment: "品目ancestry"
    t.string   "category_name",                                                         comment: "品目名称"
    t.string   "daily_xm",                                                              comment: "项目"
    t.decimal  "total",             precision: 13, scale: 2, default: 0.0, null: false, comment: "总金额"
    t.text     "summary",                                                               comment: "基本情况（备注）"
    t.text     "details",                                                               comment: "明细"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "daily_cost_items", ["daily_category_id"], name: "index_daily_cost_items_on_daily_category_id", using: :btree
  add_index "daily_cost_items", ["daily_cost_id"], name: "index_daily_cost_items_on_daily_cost_id", using: :btree

  create_table "daily_costs", force: true do |t|
    t.integer  "rule_id",                                                                              comment: "流程ID"
    t.string   "rule_step",                                                                            comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.string   "name",                                                                    null: false, comment: "名称"
    t.string   "sn",                                                                                   comment: "凭证编号（验收单号）"
    t.integer  "department_id"
    t.string   "dep_name",                                                                             comment: "采购单位名称"
    t.string   "dep_code",                                                                             comment: "采购单位real_ancestry"
    t.string   "dep_man",                                                                              comment: "采购单位联系人"
    t.decimal  "total",                            precision: 13, scale: 2, default: 0.0, null: false, comment: "总金额"
    t.date     "deliver_at",                                                                           comment: "交付时间"
    t.text     "summary",                                                                              comment: "基本情况（备注）"
    t.integer  "user_id",                                                   default: 0,   null: false, comment: "用户ID"
    t.integer  "status",        limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                              comment: "明细"
    t.text     "logs",          limit: 2147483647
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name",                                              null: false, comment: "单位名称"
    t.string   "ancestry",                                                       comment: "祖先节点"
    t.integer  "ancestry_depth",                                                 comment: "层级"
    t.string   "real_ancestry",                                                  comment: "祖先和自己中是独立核算单位的节点"
    t.integer  "rule_id",                                                        comment: "流程ID"
    t.string   "rule_step",                                                      comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.integer  "status",         limit: 2,          default: 0,     null: false, comment: "状态"
    t.string   "short_name",                                                     comment: "单位简称"
    t.string   "old_name",                                                       comment: "曾用名"
    t.boolean  "dep_type",                          default: false, null: false, comment: "0-独立核算单位/1-部门"
    t.string   "bank",                                                           comment: "开户银行"
    t.string   "bank_code",                                                      comment: "银行code"
    t.string   "bank_account",                                                   comment: "银行账号"
    t.string   "org_code",                                                       comment: "组织机构代码"
    t.string   "legal_name",                                                     comment: "单位法人姓名"
    t.string   "legal_number",                                                   comment: "单位法人身份证"
    t.integer  "area_id",                                                        comment: "地区id"
    t.string   "address",                                                        comment: "详细地址"
    t.string   "post_code",                                                      comment: "邮编"
    t.string   "website",                                                        comment: "公司网址"
    t.string   "capital",                                                        comment: "注册资金"
    t.string   "license",                                                        comment: "营业执照"
    t.string   "tax",                                                            comment: "税务登记证"
    t.string   "employee",                                                       comment: "职工人数"
    t.string   "turnover",                                                       comment: "年营业额"
    t.string   "tel",                                                            comment: "电话（总机）"
    t.string   "fax",                                                            comment: "传真"
    t.text     "summary",                                                        comment: "单位介绍"
    t.boolean  "is_blacklist",                      default: false, null: false, comment: "是否在黑名单中"
    t.integer  "sort",                                                           comment: "排序号"
    t.text     "details",                                                        comment: "明细"
    t.text     "logs",           limit: 2147483647,                              comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "old_id"
    t.string   "old_table"
    t.boolean  "is_secret"
    t.float    "comment_total",  limit: 24
    t.string   "rys_code",                                                       comment: "日预算对应单位code"
    t.boolean  "rys_switch"
  end

  add_index "departments", ["ancestry"], name: "index_departments_on_ancestry", using: :btree
  add_index "departments", ["name"], name: "index_departments_on_name", using: :btree
  add_index "departments", ["old_id", "old_table"], name: "index_departments_on_old_id_and_old_table", using: :btree
  add_index "departments", ["real_ancestry"], name: "index_departments_on_real_ancestry", using: :btree

  create_table "departments_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "departments_uploads", ["master_id"], name: "index_departments_uploads_on_master_id", using: :btree

  create_table "faq_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "faq_uploads", ["master_id"], name: "index_faq_uploads_on_master_id", using: :btree

  create_table "faqs", force: true do |t|
    t.string   "catalog",                                                   comment: "分类信息"
    t.text     "title",                                                     comment: "标题/问题"
    t.text     "content",                                                   comment: "内容/答案"
    t.integer  "sort",                                                      comment: "排序"
    t.integer  "ask_user_id",                                               comment: "提问者ID"
    t.string   "ask_user_name",                                             comment: "提问者名字"
    t.string   "ask_dep_name",                                              comment: "提问者单位"
    t.integer  "user_id",                          default: 0, null: false, comment: "自己发布自己回答ID"
    t.integer  "status",        limit: 2,          default: 0, null: false, comment: "状态"
    t.text     "details",                                                   comment: "明细"
    t.text     "logs",          limit: 2147483647,                          comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fixed_assets", force: true do |t|
    t.integer  "category_id"
    t.string   "category_name"
    t.string   "category_code",                                                            null: false, comment: "车类别"
    t.string   "sn",                                                                       null: false
    t.string   "name"
    t.decimal  "gouzhi_jiage",                      precision: 13, scale: 2, default: 0.0, null: false, comment: "购置价格"
    t.decimal  "gouzhi_shui",                       precision: 13, scale: 2, default: 0.0, null: false, comment: "购置税"
    t.date     "gouzhi_riqi",                                                              null: false, comment: "购置日期"
    t.date     "qiyong_riqi",                                                              null: false, comment: "启用日期"
    t.date     "baofei_riqi",                                                                           comment: "报废日期"
    t.date     "zhuanyi_riqi",                                                                          comment: "转移日期"
    t.string   "zhuanyi_danwei",                                                                        comment: "转移单位"
    t.decimal  "zhejiulv",                          precision: 4,  scale: 2,               null: false
    t.string   "fuzeren"
    t.integer  "user_id",                                                    default: 0,   null: false, comment: "用户ID"
    t.integer  "department_id",                                                                         comment: "用户"
    t.string   "dep_name",                                                                              comment: "真实单位"
    t.string   "bumen",                                                                                 comment: "使用部门"
    t.integer  "status",         limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                               comment: "明细"
    t.text     "logs",           limit: 2147483647,                                                     comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "asset_status",                                                                          comment: "车辆状态"
  end

  create_table "invoice_info_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_info_uploads", ["master_id"], name: "index_invoice_info_uploads_on_master_id", using: :btree

  create_table "invoice_infos", force: true do |t|
    t.integer  "department_id",                    default: 0,               comment: "单位id"
    t.integer  "user_id",                          default: 0,  null: false, comment: "用户ID"
    t.string   "name",                                          null: false, comment: "单位名称（全称）"
    t.string   "tax",                                                        comment: "纳税人识别号"
    t.string   "address",                                                    comment: "注册详细地址"
    t.string   "tel",                                                        comment: "注册电话"
    t.string   "bank",                                                       comment: "开户银行"
    t.string   "bank_account",                                               comment: "开户银行账号"
    t.string   "license",                                                    comment: "营业执照号"
    t.string   "email",                                                      comment: "电子邮箱"
    t.string   "mobile",                                                     comment: "手机"
    t.string   "user_name",                                                  comment: "增票收票人姓名"
    t.string   "user_tel",                                                   comment: "增票收票人电话"
    t.string   "user_addr",                                                  comment: "增票收票人详细地址"
    t.integer  "status",        limit: 2,          default: 65, null: false, comment: "状态"
    t.text     "details",                                                    comment: "明细"
    t.text     "logs",          limit: 2147483647,                           comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invoice_infos", ["department_id"], name: "index_invoice_infos_on_department_id", using: :btree
  add_index "invoice_infos", ["user_id", "department_id"], name: "index_invoice_infos_on_user_id_and_department_id", unique: true, using: :btree
  add_index "invoice_infos", ["user_id"], name: "index_invoice_infos_on_user_id", unique: true, using: :btree

  create_table "item_categories", force: true do |t|
    t.integer  "item_id",     null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_departments", force: true do |t|
    t.integer  "item_id",                   null: false
    t.integer  "department_id"
    t.string   "name",                                   comment: "单位名称"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "classify",      default: 0, null: false, comment: "入围供应商分级 1:A级 2:B级 3:C级 0:待定"
  end

  create_table "items", force: true do |t|
    t.string   "name",                                                        comment: "项目名称"
    t.boolean  "item_type",                      default: false, null: false, comment: "用户类型 0:厂家供货,1:代理商供货"
    t.datetime "begin_time",                                                  comment: "有效期开始时间"
    t.datetime "end_time",                                                    comment: "有效期截止时间"
    t.text     "dep_names",                                                   comment: "入围供应商名单"
    t.text     "categoryids",                                                 comment: "品目id"
    t.integer  "status",      limit: 2,          default: 0,     null: false, comment: "状态"
    t.text     "details",                                                     comment: "明细"
    t.text     "logs",        limit: 2147483647,                              comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "is_classify",                    default: false, null: false, comment: "入围供应商是否分级"
    t.string   "short_name",                                                  comment: "项目别名"
  end

  create_table "mall_tokens", force: true do |t|
    t.string   "name",         null: false, comment: "名称"
    t.string   "access_token", null: false, comment: "token"
    t.datetime "due_at",       null: false, comment: "有效期"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menus", force: true do |t|
    t.string   "name",                                              null: false, comment: "名称"
    t.string   "ancestry",                                                       comment: "祖先节点"
    t.integer  "ancestry_depth",                                                 comment: "层级"
    t.string   "icon",                                                           comment: "图标"
    t.string   "route_path",                                                     comment: "url"
    t.string   "can_opt_action",                                                 comment: "用于cancancan判断用户是否有这个操作 例如：Department|update"
    t.integer  "status",         limit: 2,          default: 0,     null: false, comment: "状态"
    t.integer  "sort",                                                           comment: "排序"
    t.boolean  "is_show",                           default: false, null: false, comment: "是否显示菜单"
    t.boolean  "is_auto",                           default: false, null: false, comment: "是否自动获取"
    t.boolean  "is_blank",                          default: false, null: false, comment: "是否弹出新页面"
    t.text     "details",                                                        comment: "明细"
    t.text     "logs",           limit: 2147483647,                              comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
  end

  add_index "menus", ["ancestry"], name: "index_menus_on_ancestry", using: :btree
  add_index "menus", ["route_path"], name: "index_menus_on_route_path", using: :btree
  add_index "menus", ["user_type"], name: "index_menus_on_user_type", using: :btree

  create_table "msg_users", force: true do |t|
    t.integer  "user_id",                    null: false, comment: "接受人"
    t.integer  "msg_id",                     null: false, comment: "短消息id"
    t.boolean  "is_read",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "msg_users", ["is_read"], name: "index_msg_users_on_is_read", using: :btree
  add_index "msg_users", ["msg_id"], name: "index_msg_users_on_msg_id", using: :btree
  add_index "msg_users", ["user_id", "msg_id"], name: "index_msg_users_on_user_id_and_msg_id", unique: true, using: :btree
  add_index "msg_users", ["user_id"], name: "index_msg_users_on_user_id", using: :btree

  create_table "msgs", force: true do |t|
    t.string   "title",                         comment: "标题"
    t.text     "content",                       comment: "内容"
    t.integer  "user_id",                       comment: "写信人id"
    t.string   "user_name",                     comment: "写信人"
    t.text     "logs",       limit: 2147483647, comment: "日志"
    t.integer  "send_type",  limit: 2,          comment: "接受人群"
    t.text     "send_tos",                      comment: "具体接收人"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "msgs", ["user_id"], name: "index_msgs_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "sender_id",                         null: false, comment: "发送者ID"
    t.integer  "receiver_id",                       null: false, comment: "接收者ID"
    t.integer  "category",                          null: false, comment: "类别ID"
    t.string   "title",                                          comment: "标题"
    t.string   "content",                                        comment: "内容"
    t.integer  "status",      limit: 2, default: 0, null: false, comment: "状态"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["receiver_id"], name: "index_notifications_on_receiver_id", using: :btree
  add_index "notifications", ["sender_id"], name: "index_notifications_on_sender_id", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "rule_id",                                                                               comment: "流程ID"
    t.string   "rule_step",                                                                             comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.string   "name",                                                                     null: false, comment: "名称"
    t.string   "sn",                                                                                    comment: "凭证编号（验收单号）"
    t.string   "contract_sn",                                                                           comment: "合同编号"
    t.string   "buyer_name",                                                                            comment: "采购单位名称"
    t.string   "payer",                                                                                 comment: "发票抬头"
    t.integer  "buyer_id",                                                                              comment: "采购单位ID"
    t.string   "buyer_code",                                                                            comment: "采购单位real_ancestry"
    t.string   "buyer_man",                                                                             comment: "采购单位联系人"
    t.string   "buyer_tel",                                                                             comment: "采购单位联系人座机"
    t.string   "buyer_mobile",                                                                          comment: "采购单位联系人手机"
    t.string   "buyer_addr",                                                                            comment: "采购单位地址"
    t.string   "seller_name",                                                                           comment: "供应商单位名称"
    t.integer  "seller_id",                                                                             comment: "供应商单位ID"
    t.string   "seller_code",                                                                           comment: "供应商单位real_ancestry"
    t.string   "seller_man",                                                                            comment: "供应商单位联系人"
    t.string   "seller_tel",                                                                            comment: "供应商单位联系人座机"
    t.string   "seller_mobile",                                                                         comment: "供应商单位联系人手机"
    t.string   "seller_addr",                                                                           comment: "供应商单位地址"
    t.decimal  "budget_money",                      precision: 13, scale: 2
    t.decimal  "total",                             precision: 13, scale: 2, default: 0.0, null: false, comment: "总金额"
    t.date     "deliver_at",                                                                            comment: "交付时间"
    t.string   "invoice_number",                                                                        comment: "发票编号"
    t.text     "summary",                                                                               comment: "基本情况（备注）"
    t.integer  "user_id",                                                    default: 0,   null: false, comment: "用户ID"
    t.integer  "status",         limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.datetime "effective_time",                                                                        comment: "生效时间（统计）"
    t.text     "details",                                                                               comment: "明细"
    t.text     "logs",           limit: 2147483647,                                                     comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "yw_type"
    t.string   "sfz"
    t.decimal  "deliver_fee",                       precision: 20, scale: 2, default: 0.0, null: false
    t.decimal  "other_fee",                         precision: 20, scale: 2, default: 0.0, null: false
    t.text     "other_fee_desc"
    t.boolean  "item_type"
    t.integer  "budget_id"
    t.string   "ht_template"
    t.integer  "comment_total"
    t.text     "comment_detail"
    t.integer  "audit_user_id"
    t.integer  "mall_id"
    t.integer  "rate_id",                                                                               comment: "评价id"
    t.decimal  "rate_total",                        precision: 13, scale: 2,                            comment: "评价得分"
    t.string   "plan_key",                                                                              comment: "计划采购item_id_category_id"
  end

  add_index "orders", ["budget_id"], name: "index_orders_on_budget_id", using: :btree
  add_index "orders", ["buyer_code"], name: "index_orders_on_buyer_code", using: :btree
  add_index "orders", ["buyer_id"], name: "index_orders_on_buyer_id", using: :btree
  add_index "orders", ["contract_sn"], name: "index_orders_on_contract_sn", using: :btree
  add_index "orders", ["rule_id"], name: "index_orders_on_rule_id", using: :btree
  add_index "orders", ["seller_id"], name: "index_orders_on_seller_id", using: :btree
  add_index "orders", ["seller_name"], name: "index_orders_on_seller_name", using: :btree
  add_index "orders", ["sn"], name: "index_orders_on_sn", unique: true, using: :btree
  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree
  add_index "orders", ["yw_type"], name: "index_orders_on_yw_type", using: :btree

  create_table "orders_items", force: true do |t|
    t.integer  "order_id",                                default: 0,   null: false, comment: "订单ID"
    t.integer  "category_id",                                                        comment: "品目"
    t.string   "category_code",                                         null: false, comment: "品目ancestry"
    t.string   "category_name",                                                      comment: "品目名称"
    t.integer  "product_id",                              default: 0,   null: false, comment: "产品ID"
    t.string   "brand",                                                              comment: "品牌"
    t.string   "model",                                                              comment: "型号"
    t.string   "version",                                                            comment: "版本号"
    t.string   "unit",                                                               comment: "计量单位"
    t.decimal  "market_price",   precision: 13, scale: 2,                            comment: "市场价格"
    t.decimal  "bid_price",      precision: 13, scale: 2,                            comment: "中标价格"
    t.decimal  "price",          precision: 13, scale: 2, default: 0.0, null: false, comment: "成交价格"
    t.decimal  "quantity",       precision: 13, scale: 3, default: 0.0, null: false, comment: "数量"
    t.decimal  "total",          precision: 13, scale: 2, default: 0.0, null: false, comment: "总金额"
    t.text     "summary",                                                            comment: "基本情况（备注）"
    t.text     "details",                                                            comment: "明细"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id"
    t.integer  "agent_id"
    t.text     "comment_detail"
    t.integer  "old_id"
    t.string   "old_table"
  end

  add_index "orders_items", ["category_code"], name: "index_orders_items_on_category_code", using: :btree
  add_index "orders_items", ["category_id"], name: "index_orders_items_on_category_id", using: :btree
  add_index "orders_items", ["old_id", "old_table"], name: "index_orders_items_on_old_id_and_old_table", using: :btree
  add_index "orders_items", ["order_id"], name: "index_orders_items_on_order_id", using: :btree

  create_table "orders_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders_uploads", ["master_id"], name: "index_orders_uploads_on_master_id", using: :btree

  create_table "other_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "yw_type",                         comment: "业务类型"
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "other_uploads", ["master_id", "yw_type"], name: "index_other_uploads_on_master_id_and_yw_type", using: :btree

  create_table "pay_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pay_uploads", ["master_id"], name: "index_pay_uploads_on_master_id", using: :btree

  create_table "pays", force: true do |t|
    t.text     "orderids",                                                       comment: "订单ID"
    t.integer  "is_rys",                                default: 0,              comment: "选择日预算支付或非日预算支付"
    t.decimal  "total",        precision: 13, scale: 2,                          comment: "本次付款金额"
    t.integer  "status",                                default: 6, null: false
    t.datetime "pay_at",                                                         comment: "付款日期"
    t.string   "buyer_name",                                                     comment: "申请单位"
    t.string   "bumen",                                                          comment: "申请部门"
    t.string   "user_name",                                                      comment: "申请人"
    t.date     "wish_pay_at",                                                    comment: "期望付款日期"
    t.string   "asset_name",                                                     comment: "资产名称"
    t.string   "asset_type",                                                     comment: "资产类型"
    t.string   "seller_name",                                                    comment: "收款方单位名称"
    t.text     "upload_url",                                                     comment: "审批附件URL"
    t.string   "pay_type",                                                       comment: "结算方式"
    t.string   "account",                                                        comment: "收款方账号"
    t.string   "account_name",                                                   comment: "收款方户名"
    t.string   "bank",                                                           comment: "收款方开户行"
    t.string   "country",                                                        comment: "收款方银行所属国家"
    t.string   "province",                                                       comment: "收款方银行所属省"
    t.string   "city",                                                           comment: "收款方银行所属城市"
    t.text     "summary",                                                        comment: "摘要"
    t.text     "details",                                                        comment: "明细"
    t.text     "logs",                                                           comment: "日志"
    t.integer  "user_id",                               default: 0, null: false, comment: "用户ID"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "mall_id",                                                        comment: "商城订单ID"
    t.string   "pay_dep_name",                                                   comment: "付款账号（付款方单位名称）"
    t.string   "pay_account",                                                    comment: "付款方银行账号"
    t.boolean  "is_push",                                                        comment: "是否推送"
  end

  create_table "plan_item_categories", force: true do |t|
    t.integer  "plan_item_id",  null: false
    t.integer  "category_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id",              comment: "中标单位id"
    t.string   "dep_name",                   comment: "中标单位名称"
  end

  create_table "plan_item_results", force: true do |t|
    t.integer  "plan_item_id",  null: false
    t.integer  "category_id",   null: false
    t.string   "category_name",              comment: "品目名称"
    t.text     "name",                       comment: "中标单位名称"
    t.text     "dep_ids",                    comment: "中标单位id"
    t.text     "details",                    comment: "明细"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plan_items", force: true do |t|
    t.string   "name",                                                    comment: "采购计划项目名称"
    t.datetime "end_time",                                                comment: "上报计划截止时间"
    t.text     "categoryids",                                             comment: "品目id"
    t.integer  "status",      limit: 2,          default: 0, null: false, comment: "状态"
    t.text     "details",                                                 comment: "明细"
    t.text     "logs",        limit: 2147483647,                          comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "item_id",                                                 comment: "入围项目ID"
  end

  create_table "plan_products", force: true do |t|
    t.integer  "plan_id",                             default: 0,   null: false, comment: "订单ID"
    t.date     "deliver_at",                                                     comment: "要求到货日期"
    t.decimal  "quantity",   precision: 13, scale: 3, default: 0.0, null: false, comment: "数量"
    t.string   "unit",                                                           comment: "计量单位"
    t.decimal  "price",      precision: 13, scale: 2, default: 0.0, null: false, comment: "预算单价（元）"
    t.decimal  "total",      precision: 13, scale: 2, default: 0.0, null: false, comment: "预算总价（元）"
    t.text     "summary",                                                        comment: "基本情况（备注）"
    t.text     "details",                                                        comment: "明细"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plan_products", ["plan_id"], name: "index_plan_products_on_plan_id", using: :btree

  create_table "plan_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plan_uploads", ["master_id"], name: "index_plan_uploads_on_master_id", using: :btree

  create_table "plans", force: true do |t|
    t.integer  "plan_item_id",                                              default: 0,   null: false, comment: "项目ID"
    t.integer  "category_id",                                               default: 0,   null: false, comment: "品目ID"
    t.string   "category_code",                                             default: "0", null: false, comment: "品目编号"
    t.integer  "rule_id",                                                                              comment: "流程ID"
    t.string   "rule_step",                                                                            comment: "审核流程 例：start 、分公司审核、总公司审核、done"
    t.string   "name",                                                                    null: false, comment: "名称"
    t.string   "sn",                                                                                   comment: "采购计划编号"
    t.integer  "department_id"
    t.string   "dep_name",                                                                             comment: "采购单位名称"
    t.string   "dep_code",                                                                             comment: "采购单位real_ancestry"
    t.string   "dep_man",                                                                              comment: "采购单位联系人"
    t.string   "dep_tel",                                                                              comment: "采购单位联系人座机"
    t.string   "dep_mobile",                                                                           comment: "采购单位联系人手机"
    t.decimal  "total",                            precision: 13, scale: 2, default: 0.0, null: false, comment: "总预算金额"
    t.text     "summary",                                                                              comment: "基本情况（备注）"
    t.integer  "user_id",                                                   default: 0,   null: false, comment: "用户ID"
    t.integer  "status",        limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                              comment: "明细"
    t.text     "logs",          limit: 2147483647,                                                     comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "area_id"
  end

  add_index "plans", ["category_code"], name: "index_plans_on_category_code", using: :btree
  add_index "plans", ["category_id"], name: "index_plans_on_category_id", using: :btree
  add_index "plans", ["plan_item_id"], name: "index_plans_on_plan_item_id", using: :btree
  add_index "plans", ["sn"], name: "index_plans_on_sn", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.integer  "item_id",                                                   default: 0,   null: false, comment: "项目ID"
    t.integer  "category_id",                                               default: 0,   null: false, comment: "品目ID"
    t.string   "category_code",                                             default: "0", null: false, comment: "品目编号"
    t.string   "brand",                                                                                comment: "品牌"
    t.string   "model",                                                                                comment: "型号"
    t.string   "version",                                                                              comment: "版本号"
    t.string   "unit",                                                                                 comment: "计量单位"
    t.decimal  "market_price",                     precision: 13, scale: 2,                            comment: "市场价格"
    t.decimal  "bid_price",                        precision: 13, scale: 2,                            comment: "中标价格"
    t.text     "summary",                                                                              comment: "基本描述"
    t.integer  "status",        limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                              comment: "明细"
    t.integer  "user_id",                                                   default: 0,   null: false, comment: "用户ID"
    t.text     "logs",          limit: 2147483647,                                                     comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id",                                             default: 0,   null: false, comment: "单位ID"
    t.integer  "rule_id"
    t.string   "rule_step"
  end

  add_index "products", ["category_code"], name: "index_products_on_category_code", using: :btree
  add_index "products", ["category_id"], name: "index_products_on_category_id", using: :btree
  add_index "products", ["department_id", "item_id"], name: "index_products_on_department_id_and_item_id", using: :btree
  add_index "products", ["department_id"], name: "index_products_on_department_id", using: :btree
  add_index "products", ["item_id"], name: "index_products_on_item_id", using: :btree
  add_index "products", ["user_id"], name: "index_products_on_user_id", using: :btree

  create_table "products_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products_uploads", ["master_id"], name: "index_products_uploads_on_master_id", using: :btree

  create_table "rates", force: true do |t|
    t.decimal  "jhsd",                          precision: 13, scale: 2,                          comment: "交货速度"
    t.decimal  "fwtd",                          precision: 13, scale: 2,                          comment: "服务态度"
    t.decimal  "cpzl",                          precision: 13, scale: 2,                          comment: "产品质量"
    t.decimal  "jjwt",                          precision: 13, scale: 2,                          comment: "解决问题能力"
    t.decimal  "dqhf",                          precision: 13, scale: 2,                          comment: "定期回访"
    t.decimal  "xcfw",                          precision: 13, scale: 2,                          comment: "现场服务"
    t.decimal  "bpbj",                          precision: 13, scale: 2,                          comment: "备品备件"
    t.decimal  "total",                         precision: 13, scale: 2,                          comment: "评价得分"
    t.text     "summary",                                                                         comment: "备注"
    t.integer  "user_id",                                                default: 0, null: false, comment: "用户ID"
    t.integer  "status",     limit: 2,                                   default: 0, null: false, comment: "状态"
    t.text     "details",                                                                         comment: "明细"
    t.text     "logs",       limit: 2147483647,                                                   comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", force: true do |t|
    t.string   "name",                                                     comment: "名称"
    t.text     "rule_xml"
    t.text     "audit_reason",                                             comment: "审核理由"
    t.integer  "status",       limit: 2,          default: 0, null: false, comment: "状态"
    t.text     "details",                                                  comment: "明细"
    t.text     "logs",         limit: 2147483647,                          comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.string   "yw_type"
  end

  create_table "settings", force: true do |t|
    t.string   "var",                   null: false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "suggestions", force: true do |t|
    t.text     "content",                          null: false, comment: "意见反馈"
    t.string   "email",                                         comment: "电子邮箱"
    t.string   "mobile",                                        comment: "手机"
    t.string   "QQ",                                            comment: "QQ号"
    t.integer  "status",     limit: 2, default: 0, null: false, comment: "状态"
    t.text     "logs",                                          comment: "日志"
    t.integer  "user_id",                                       comment: "用户ID"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "suggestions_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "suggestions_uploads", ["master_id"], name: "index_suggestions_uploads_on_master_id", using: :btree

  create_table "task_queues", force: true do |t|
    t.integer  "to_do_list_id",                                comment: "待办事项ID"
    t.string   "class_name",    default: "Order", null: false, comment: "类名"
    t.integer  "obj_id",        default: 0,       null: false, comment: "实例ID"
    t.integer  "user_id",                                      comment: "用户ID"
    t.integer  "menu_id",                                      comment: "菜单ID"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dep_id"
  end

  add_index "task_queues", ["class_name", "obj_id"], name: "index_task_queues_on_class_name_and_obj_id", using: :btree
  add_index "task_queues", ["dep_id"], name: "index_task_queues_on_dep_id", using: :btree
  add_index "task_queues", ["menu_id"], name: "index_task_queues_on_menu_id", using: :btree
  add_index "task_queues", ["to_do_list_id"], name: "index_task_queues_on_to_do_list_id", using: :btree
  add_index "task_queues", ["user_id"], name: "index_task_queues_on_user_id", using: :btree

  create_table "to_do_lists", force: true do |t|
    t.string   "name",                                                   comment: "名称"
    t.string   "list_url",                                               comment: "列表url"
    t.string   "audit_url",                                              comment: "审核url"
    t.integer  "sort",                                                   comment: "排序"
    t.integer  "status",     limit: 2,          default: 0, null: false, comment: "状态"
    t.text     "details",                                                comment: "明细"
    t.text     "logs",       limit: 2147483647,                          comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfer_items", force: true do |t|
    t.integer  "transfer_id",                             default: 0,   null: false, comment: "主表ID"
    t.integer  "category_id",                                                        comment: "品目"
    t.string   "category_code",                                         null: false, comment: "品目ancestry"
    t.string   "category_name",                                                      comment: "品目名称"
    t.string   "unit",                                                               comment: "计量单位"
    t.decimal  "original_price", precision: 13, scale: 2,                            comment: "资产原值"
    t.decimal  "net_price",      precision: 13, scale: 2,                            comment: "资产净值"
    t.decimal  "transfer_price", precision: 13, scale: 2, default: 0.0, null: false, comment: "转让资金"
    t.decimal  "num",            precision: 13, scale: 3, default: 0.0, null: false, comment: "数量"
    t.integer  "product_status",                                                     comment: "设备状态"
    t.text     "description",                                                        comment: "技术规格或产品说明"
    t.text     "summary",                                                            comment: "基本情况（备注）"
    t.text     "details",                                                            comment: "明细"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transfer_items", ["category_code"], name: "index_transfer_items_on_category_code", using: :btree
  add_index "transfer_items", ["transfer_id"], name: "index_transfer_items_on_transfer_id", using: :btree

  create_table "transfer_uploads", force: true do |t|
    t.integer  "master_id",           default: 0
    t.string   "upload_file_name",                comment: "文件名称"
    t.string   "upload_content_type",             comment: "文件类型"
    t.integer  "upload_file_size",                comment: "文件大小"
    t.datetime "upload_updated_at",               comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transfer_uploads", ["master_id"], name: "index_transfer_uploads_on_master_id", using: :btree

  create_table "transfers", force: true do |t|
    t.string   "name",                                                                    null: false, comment: "项目名称"
    t.string   "sn",                                                                                   comment: "项目编号"
    t.integer  "department_id",                                                                        comment: "单位"
    t.string   "dep_name",                                                                             comment: "采购单位"
    t.string   "dep_code",                                                                             comment: "采购单位real_ancestry"
    t.string   "dep_man",                                                                              comment: "采购单位联系人"
    t.string   "dep_tel",                                                                              comment: "采购单位座机"
    t.string   "dep_mobile",                                                                           comment: "采购单位联系人电话"
    t.string   "dep_addr",                                                                             comment: "采购单位地址"
    t.decimal  "total",                            precision: 13, scale: 2, default: 0.0, null: false, comment: "总金额"
    t.text     "summary",                                                                              comment: "基本情况（备注）"
    t.integer  "user_id",                                                   default: 0,   null: false, comment: "用户ID"
    t.integer  "status",        limit: 2,                                   default: 0,   null: false, comment: "状态"
    t.text     "details",                                                                              comment: "明细"
    t.text     "logs",          limit: 2147483647,                                                     comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "submit_time"
    t.integer  "rule_id"
    t.string   "rule_step"
  end

  add_index "transfers", ["sn"], name: "index_transfers_on_sn", unique: true, using: :btree

  create_table "umeditor_files", force: true do |t|
    t.string   "original_name",              comment: "原始名称"
    t.string   "store_name",    null: false, comment: "保存名称"
    t.integer  "file_size",                  comment: "文件大小"
    t.string   "content_type",               comment: "文件类型"
    t.string   "description",                comment: "文件描述"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "umeditor_files", ["user_id"], name: "index_umeditor_files_on_user_id", using: :btree

  create_table "uploads", force: true do |t|
    t.integer  "master_id"
    t.string   "master_type"
    t.string   "upload_file_name",    comment: "文件名称"
    t.string   "upload_content_type", comment: "文件类型"
    t.integer  "upload_file_size",    comment: "文件大小"
    t.datetime "upload_updated_at",   comment: "时间戳"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "uploads", ["master_id", "master_type"], name: "index_uploads_on_master_id_and_master_type", using: :btree

  create_table "user_categories", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "category_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_categories", ["category_id"], name: "index_user_categories_on_category_id", using: :btree
  add_index "user_categories", ["user_id", "category_id"], name: "index_user_categories_on_user_id_and_category_id", unique: true, using: :btree
  add_index "user_categories", ["user_id"], name: "index_user_categories_on_user_id", using: :btree

  create_table "user_menus", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "menu_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_menus", ["menu_id"], name: "index_user_menus_on_menu_id", using: :btree
  add_index "user_menus", ["user_id", "menu_id"], name: "index_user_menus_on_user_id_and_menu_id", unique: true, using: :btree
  add_index "user_menus", ["user_id"], name: "index_user_menus_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.integer  "department_id",                         default: 0,                  comment: "单位id"
    t.string   "login",                                                              comment: "登录名"
    t.string   "name",                                                               comment: "姓名"
    t.boolean  "is_admin",                              default: false, null: false, comment: "是否管理员"
    t.boolean  "is_personal",                           default: false, null: false
    t.text     "menuids",                                                            comment: "角色id"
    t.text     "categoryids",                                                        comment: "品目id"
    t.string   "password_digest",                                       null: false, comment: "密码"
    t.string   "remember_token",                                                     comment: "自动登录"
    t.date     "birthday",                                                           comment: "出生日期"
    t.string   "portrait",                                                           comment: "头像"
    t.string   "gender",             limit: 2,                                       comment: "性别"
    t.string   "identity_num",                                                       comment: "身份证"
    t.string   "identity_pic",                                                       comment: "身份证图片"
    t.string   "email",                                                              comment: "电子邮箱"
    t.string   "mobile",                                                             comment: "手机"
    t.string   "tel",                                                                comment: "电话"
    t.string   "fax",                                                                comment: "传真"
    t.integer  "status",                                default: 0,     null: false, comment: "状态"
    t.string   "duty",                                                               comment: "职务"
    t.string   "professional_title",                                                 comment: "职称"
    t.text     "bio",                                                                comment: "个人简历"
    t.text     "details",                                                            comment: "明细"
    t.text     "logs",               limit: 2147483647,                              comment: "日志"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cart"
  end

  add_index "users", ["department_id"], name: "index_users_on_department_id", using: :btree
  add_index "users", ["login"], name: "index_users_on_login", unique: true, using: :btree

end
