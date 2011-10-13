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

ActiveRecord::Schema.define(:version => 20111012041250) do

  create_table "logins", :force => true do |t|
    t.string "username", :limit => 32
    t.string "password", :limit => 32
  end

  create_table "user_counts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "uploads",    :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
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

end
