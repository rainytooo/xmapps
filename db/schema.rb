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

ActiveRecord::Schema.define(:version => 20110527080931) do

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

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "desc_content"
    t.string   "addr"
    t.datetime "start_date"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], :name => "idx_key"

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

  create_table "user_counts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "uploads",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_counts", ["user_id"], :name => "fk_user_counts_user"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "passwd"
    t.integer  "dz_common_id"
    t.integer  "regdate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
