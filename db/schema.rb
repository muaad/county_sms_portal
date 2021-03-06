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

ActiveRecord::Schema.define(version: 20150611190846) do

  create_table "accounts", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "account_id"
  end

  add_index "categories", ["account_id"], name: "index_categories_on_account_id"

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "location"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "account_id"
    t.integer  "group_id"
    t.boolean  "favorite",     default: false
  end

  add_index "contacts", ["account_id"], name: "index_contacts_on_account_id"
  add_index "contacts", ["group_id"], name: "index_contacts_on_group_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "message_categories", force: :cascade do |t|
    t.integer  "message_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "account_id"
  end

  add_index "message_categories", ["account_id"], name: "index_message_categories_on_account_id"
  add_index "message_categories", ["category_id"], name: "index_message_categories_on_category_id"
  add_index "message_categories", ["message_id"], name: "index_message_categories_on_message_id"

  create_table "messages", force: :cascade do |t|
    t.text     "text"
    t.integer  "contact_id"
    t.boolean  "incoming",   default: true
    t.integer  "user_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "account_id"
    t.boolean  "read",       default: false
  end

  add_index "messages", ["account_id"], name: "index_messages_on_account_id"
  add_index "messages", ["contact_id"], name: "index_messages_on_contact_id"
  add_index "messages", ["user_id"], name: "index_messages_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
