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

ActiveRecord::Schema.define(version: 20140603071219) do

  create_table "rooms", force: true do |t|
    t.integer  "entry_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.decimal  "rent"
    t.decimal  "util_fee"
    t.integer  "apt_roomnum"
    t.integer  "apt_bathnum"
    t.string   "apt_gender"
    t.integer  "univ_id"
    t.integer  "acpt_distance"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "usr_name"
    t.string   "landlord"
    t.string   "image_url"
    t.string   "email"
    t.decimal  "tel"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "universities", force: true do |t|
    t.string   "univ_name"
    t.integer  "univ_id"
    t.string   "univ_addr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
