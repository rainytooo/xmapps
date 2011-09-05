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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110905013831) do

  create_table "applies", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "mobile"
    t.string   "school"
    t.integer  "age"
    t.string   "city"
    t.integer  "campaign_req"
    t.integer  "campaign_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "campany",      :limit => 64
    t.string   "diqu_code",    :limit => 32, :default => "010"
  end

  create_table "ask_answers", :force => true do |t|
    t.integer  "ask_id"
    t.integer  "user_id"
    t.string   "username",   :limit => 32
    t.integer  "badrate"
    t.integer  "goodrate"
    t.text     "content"
    t.integer  "ifcheck",    :limit => 1,  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ask_answers", ["ask_id"], :name => "fk_answers_ask"
  add_index "ask_answers", ["user_id"], :name => "fk_answers_user"

  create_table "ask_types", :force => true do |t|
    t.string   "name",       :limit => 32
    t.integer  "pid",                      :default => 0
    t.integer  "disorder",                 :default => 0
    t.integer  "asksnum",                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "asks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ask_type_id"
    t.string   "typename",            :limit => 128
    t.string   "title",               :limit => 128
    t.integer  "expiredtime"
    t.integer  "solvetime"
    t.integer  "bestanswer"
    t.integer  "bestanswer_uid"
    t.string   "bestanswer_username", :limit => 32
    t.integer  "status",              :limit => 1,   :default => 0
    t.integer  "views",                              :default => 0
    t.integer  "replies",                            :default => 0
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asks", ["ask_type_id"], :name => "fk_asks_type"
  add_index "asks", ["user_id"], :name => "fk_asks_user"

  create_table "baomings", :force => true do |t|
    t.string   "name",          :limit => 32
    t.string   "telnum",        :limit => 32
    t.string   "school",        :limit => 32
    t.integer  "age",           :limit => 3
    t.string   "city",          :limit => 32
    t.string   "zhuanye",       :limit => 32
    t.string   "tuofucj",       :limit => 32
    t.string   "baokaoxuexiao", :limit => 64
    t.string   "campaign",      :limit => 64
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "desc_content"
    t.string   "addr"
    t.datetime "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "campany",      :limit => 64
    t.string   "diqu_code",    :limit => 32, :default => "010"
  end

  create_table "dl_attachments", :force => true do |t|
    t.integer  "dl_thread_id"
    t.string   "filename",     :limit => 64
    t.string   "originname",   :limit => 128
    t.integer  "filesize",                    :default => 0
    t.string   "filepath"
    t.string   "content_type", :limit => 32
    t.integer  "is_image",     :limit => 2,   :default => 0
    t.integer  "donwloads",                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dl_attachments", ["dl_thread_id"], :name => "fk_dlattachments_dlthread"

  create_table "dl_records", :force => true do |t|
    t.integer  "user_id"
    t.integer  "thread_id"
    t.integer  "extcredits"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dl_records", ["user_id"], :name => "fk_dl_records_user"

  create_table "dl_threads", :force => true do |t|
    t.integer  "dl_type_id"
    t.integer  "user_id"
    t.string   "name",               :limit => 128
    t.string   "content_desc"
    t.text     "content"
    t.integer  "createtime"
    t.integer  "ispass",             :limit => 2,   :default => 0
    t.integer  "views",                             :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.integer  "gold",                              :default => 5
    t.integer  "level",                             :default => 0
  end

  add_index "dl_threads", ["dl_type_id"], :name => "fk_dlthreads_dltype"
  add_index "dl_threads", ["user_id"], :name => "fk_dlthreads_user"

  create_table "dl_types", :force => true do |t|
    t.integer  "dl_type_id"
    t.string   "typename",    :limit => 64
    t.integer  "type_lv",     :limit => 2,   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "keywords",    :limit => 64
    t.string   "description", :limit => 256
  end

  add_index "dl_types", ["dl_type_id"], :name => "fk_dltypes_parentdltypes"

  create_table "dz_common_member_counts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logins", :force => true do |t|
    t.string "username", :limit => 32
    t.string "password", :limit => 32
  end

  create_table "questionnaires", :force => true do |t|
    t.string   "name",        :limit => 64
    t.integer  "gender",      :limit => 3
    t.integer  "age",         :limit => 3
    t.string   "school",      :limit => 128
    t.string   "subject",     :limit => 128
    t.string   "telnum",      :limit => 12
    t.integer  "liuxue_plan", :limit => 3
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questionnaires", ["user_id"], :name => "fk_questionnaires_user"

  create_table "search_keywords", :force => true do |t|
    t.integer  "user_id"
    t.string   "keywords",   :limit => 128
    t.string   "appname",    :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "search_keywords", ["user_id"], :name => "fk_search_keywords_user"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

  create_table "source_langs", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "source_types", :force => true do |t|
    t.string "name"
  end

  create_table "sources", :force => true do |t|
    t.integer  "user_id"
    t.integer  "source_type_id"
    t.integer  "source_lang_id"
    t.integer  "dz_user_id"
    t.string   "username",            :limit => 32
    t.string   "title",               :limit => 128
    t.string   "source_desc"
    t.string   "origin_url"
    t.text     "content"
    t.string   "photo_file_name",     :limit => 128
    t.string   "photo_content_type",  :limit => 32
    t.integer  "photo_file_size"
    t.integer  "views",                              :default => 0
    t.integer  "status",                             :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "best_trans_id"
    t.integer  "best_trans_userid"
    t.string   "best_trans_username"
    t.integer  "best_trans_userdzid"
    t.integer  "excredits",                          :default => 50
  end

  add_index "sources", ["source_lang_id"], :name => "fk_sources_lang"
  add_index "sources", ["source_type_id"], :name => "fk_sources_type"
  add_index "sources", ["user_id"], :name => "fk_sources_user"

  create_table "tag_relationships", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "object_id"
    t.string   "taxonomy",   :limit => 32
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name",       :limit => 32
    t.string   "slug",       :limit => 64
    t.integer  "count",                    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tran_ranks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "dz_user_id"
    t.string   "username",        :limit => 32
    t.string   "campaign",        :limit => 32
    t.integer  "total_trans",     :limit => 8,  :default => 0
    t.integer  "best_trans",      :limit => 8,  :default => 0
    t.integer  "total_excredits",               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tran_ranks", ["user_id"], :name => "fk_tran_ranks_user"

  create_table "trans_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "translation_id"
    t.string   "username",       :limit => 32
    t.integer  "dz_user_id"
    t.string   "content",        :limit => 2000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trans_comments", ["translation_id"], :name => "fk_trans_comments_trans"
  add_index "trans_comments", ["user_id"], :name => "fk_trans_comments_user"

  create_table "translations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "source_id"
    t.integer  "source_type_id"
    t.integer  "source_lang_id"
    t.integer  "dz_user_id"
    t.string   "username",         :limit => 32
    t.string   "title"
    t.string   "source_desc"
    t.string   "origin_url"
    t.text     "content"
    t.integer  "trans_good",                     :default => 0
    t.integer  "trans_bad",                      :default => 0
    t.integer  "status",                         :default => 0
    t.integer  "views",                          :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "best_trans",                     :default => 0
    t.integer  "best_trans_score",               :default => 0
  end

  add_index "translations", ["source_id"], :name => "fk_translations_source"
  add_index "translations", ["source_lang_id"], :name => "fk_translations_lang"
  add_index "translations", ["source_type_id"], :name => "fk_translations_type"
  add_index "translations", ["user_id"], :name => "fk_translations_user"

  create_table "update_index_record", :force => true do |t|
    t.integer "last_update"
  end

  create_table "user_counts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "uploads",                  :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app_name",   :limit => 20, :default => "dl"
  end

  add_index "user_counts", ["user_id"], :name => "fk_user_counts_user"

  create_table "user_operation_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "dz_user_id"
    t.string   "username",    :limit => 32
    t.string   "app",         :limit => 32
    t.integer  "action_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_operation_logs", ["user_id"], :name => "fk_user_operation_logs_user"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "passwd"
    t.integer  "dz_common_id"
    t.integer  "regdate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zhuanti_indices", :force => true do |t|
    t.string   "title",        :limit => 128
    t.string   "content_desc", :limit => 512
    t.text     "content",      :limit => 255
    t.integer  "index_id",     :limit => 2,   :default => 1
    t.string   "campaign",     :limit => 32
    t.string   "url",          :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
