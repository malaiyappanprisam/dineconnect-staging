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

ActiveRecord::Schema.define(version: 20161113133501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "postgis"

  create_table "areas", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "digit_of_postal_code"
  end

  create_table "facilities", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "facilities_restaurants", force: :cascade do |t|
    t.integer "facility_id"
    t.integer "restaurant_id"
  end

  add_index "facilities_restaurants", ["facility_id"], name: "index_facilities_restaurants_on_facility_id", using: :btree
  add_index "facilities_restaurants", ["restaurant_id"], name: "index_facilities_restaurants_on_restaurant_id", using: :btree

  create_table "food_types", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.string   "name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "foursquare_id"
  end

  add_index "food_types", ["restaurant_id"], name: "index_food_types_on_restaurant_id", using: :btree

  create_table "food_types_restaurants", force: :cascade do |t|
    t.integer "food_type_id"
    t.integer "restaurant_id"
  end

  add_index "food_types_restaurants", ["food_type_id"], name: "index_food_types_restaurants_on_food_type_id", using: :btree
  add_index "food_types_restaurants", ["restaurant_id"], name: "index_food_types_restaurants_on_restaurant_id", using: :btree

  create_table "invites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "invitee_id"
    t.string   "channel"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "status",             default: 0
    t.integer  "restaurant_id"
    t.integer  "payment_preference", default: 0,    null: false
    t.boolean  "initiator",          default: true
    t.boolean  "showing",            default: true
  end

  add_index "invites", ["invitee_id"], name: "index_invites_on_invitee_id", using: :btree
  add_index "invites", ["restaurant_id"], name: "index_invites_on_restaurant_id", using: :btree
  add_index "invites", ["user_id", "invitee_id"], name: "index_invites_on_user_id_and_invitee_id", unique: true, using: :btree
  add_index "invites", ["user_id"], name: "index_invites_on_user_id", using: :btree

  create_table "open_schedules", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.integer  "day"
    t.integer  "hour_open"
    t.integer  "hour_close"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.time     "time_open"
    t.time     "time_close"
  end

  add_index "open_schedules", ["restaurant_id"], name: "index_open_schedules_on_restaurant_id", using: :btree

  create_table "photos", force: :cascade do |t|
    t.integer  "photoable_id"
    t.string   "photoable_type"
    t.string   "file_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "restaurant_batches", force: :cascade do |t|
    t.string   "latlong"
    t.integer  "radius"
    t.boolean  "finished",   default: false, null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "restaurant_batches_restaurants", id: false, force: :cascade do |t|
    t.integer "restaurant_batch_id"
    t.integer "restaurant_id"
  end

  add_index "restaurant_batches_restaurants", ["restaurant_batch_id"], name: "index_restaurant_batches_restaurants_on_restaurant_batch_id", using: :btree
  add_index "restaurant_batches_restaurants", ["restaurant_id"], name: "index_restaurant_batches_restaurants_on_restaurant_id", using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.string    "name"
    t.text      "address"
    t.datetime  "created_at",                                                                             null: false
    t.datetime  "updated_at",                                                                             null: false
    t.integer   "people_count"
    t.integer   "average_cost"
    t.string    "cover_id"
    t.geography "location",      limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.boolean   "active",                                                                 default: false, null: false
    t.integer   "area_id"
    t.text      "description"
    t.string    "phone_number"
    t.integer   "price"
    t.string    "foursquare_id"
  end

  add_index "restaurants", ["location"], name: "index_restaurants_on_location", using: :gist

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_tokens", force: :cascade do |t|
    t.string   "token"
    t.integer  "user_id"
    t.string   "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime  "created_at",                                                                                        null: false
    t.datetime  "updated_at",                                                                                        null: false
    t.string    "email",                                                                                             null: false
    t.string    "encrypted_password",       limit: 128,                                                              null: false
    t.string    "confirmation_token",       limit: 128
    t.string    "remember_token",           limit: 128,                                                              null: false
    t.string    "first_name"
    t.string    "last_name"
    t.string    "username"
    t.integer   "gender",                                                                            default: 0,     null: false
    t.date      "date_of_birth"
    t.string    "profession"
    t.string    "nationality"
    t.integer   "residence_status",                                                                  default: 0,     null: false
    t.integer   "interested_to_meet",                                                                default: 0,     null: false
    t.integer   "payment_preference",                                                                default: 0,     null: false
    t.text      "about_me"
    t.string    "avatar_id"
    t.string    "channel_group"
    t.integer   "role",                                                                              default: 0
    t.string    "full_name"
    t.boolean   "active",                                                                            default: true,  null: false
    t.geography "location",                 limit: {:srid=>4326, :type=>"point", :geographic=>true}
    t.string    "district"
    t.string    "uid"
    t.boolean   "onboard",                                                                           default: false
    t.string    "email_confirmation_token",                                                          default: "",    null: false
    t.datetime  "email_confirmed_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["location"], name: "index_users_on_location", using: :gist
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["votable_id", "votable_type", "voter_id", "voter_type", "vote_scope"], name: "index_votes_on_votable_id_type_voter_id_type_scope", unique: true, using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

  add_foreign_key "invites", "restaurants"
end
