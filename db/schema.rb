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

ActiveRecord::Schema.define(:version => 20100915221726) do

  create_table "activities", :force => true do |t|
    t.integer  "thing_id"
    t.string   "thing_type"
    t.string   "action"
    t.datetime "action_date"
    t.integer  "user_id"
  end

  create_table "clients", :force => true do |t|
    t.string "name"
    t.string "code"
  end

  create_table "projects", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "number"
    t.integer  "budget"
    t.string   "status"
    t.integer  "client_id"
    t.integer  "estimate_id"
    t.integer  "owner_id"
    t.integer  "creator_id"
    t.datetime "created_at"
    t.integer  "updater_id"
    t.datetime "updated_at"
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  create_table "resource_types", :force => true do |t|
    t.string  "code"
    t.string  "name"
    t.decimal "rate", :precision => 10, :scale => 0
  end

  create_table "roles", :force => true do |t|
    t.string "name"
    t.text   "description"
  end

  create_table "settings", :force => true do |t|
    t.integer "daily_resource_amount"
    t.boolean "billable"
    t.string  "company_code"
    t.string  "company_name"
    t.integer "low_utilization_level"
    t.integer "high_utilization_level"
  end

  create_table "tasks", :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.integer  "project_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "note"
    t.string   "status"
    t.integer  "budget"
    t.boolean  "billable"
    t.integer  "resource_type_id"
    t.integer  "quantity"
    t.decimal  "unit_cost",        :precision => 10, :scale => 0
  end

  create_table "tasks_users", :id => false, :force => true do |t|
    t.integer "task_id"
    t.integer "user_id"
  end

  create_table "time_entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.integer  "time_spent"
    t.integer  "extra_time"
    t.text     "note"
    t.datetime "created_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :default => "", :null => false
    t.string   "encrypted_password",  :limit => 128, :default => "", :null => false
    t.string   "password_salt",                      :default => "", :null => false
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "nick_name"
    t.string   "username"
    t.string   "telephone_number"
    t.string   "mobile_number"
    t.string   "avatar"
    t.integer  "role_id"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
