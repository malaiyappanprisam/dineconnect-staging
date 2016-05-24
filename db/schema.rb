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

ActiveRecord::Schema.define(version: 20160524163953) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "area"
    t.integer  "people_count"
    t.decimal  "average_cost"
  end

  create_table "user_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.string   "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.string   "email",                                      null: false
    t.string   "encrypted_password", limit: 128,             null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128,             null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.integer  "gender",                         default: 0, null: false
    t.date     "date_of_birth"
    t.string   "profession"
    t.string   "location"
    t.string   "nationality"
    t.integer  "residence_status",               default: 0, null: false
    t.integer  "interested_to_meet",             default: 0, null: false
    t.integer  "payment_preference",             default: 0, null: false
    t.text     "about_me"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end
