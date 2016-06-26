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

ActiveRecord::Schema.define(version: 20160626210358) do

  create_table "checkin_session_owners", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "checkin_session_id", limit: 4
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "checkin_session_owners", ["checkin_session_id"], name: "index_checkin_session_owners_on_checkin_session_id", using: :btree
  add_index "checkin_session_owners", ["user_id"], name: "index_checkin_session_owners_on_user_id", using: :btree

  create_table "checkin_session_types", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "label",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "checkin_sessions", force: :cascade do |t|
    t.string   "key",                     limit: 255
    t.string   "label",                   limit: 255
    t.integer  "checkin_session_type_id", limit: 4
    t.datetime "check_in_by"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "checkin_sessions", ["checkin_session_type_id"], name: "index_checkin_sessions_on_checkin_session_type_id", using: :btree

  create_table "checkin_users", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.integer  "checkin_session_id", limit: 4
    t.datetime "checked_in_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "attendant_id",       limit: 4
    t.boolean  "excused",            limit: 1
  end

  add_index "checkin_users", ["attendant_id"], name: "index_checkin_users_on_attendant_id", using: :btree
  add_index "checkin_users", ["checkin_session_id"], name: "index_checkin_users_on_checkin_session_id", using: :btree
  add_index "checkin_users", ["user_id"], name: "index_checkin_users_on_user_id", using: :btree

  create_table "programs", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "label",      limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "user_counselors", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "counselor_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "user_counselors", ["counselor_id"], name: "index_user_counselors_on_counselor_id", using: :btree
  add_index "user_counselors", ["user_id"], name: "index_user_counselors_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "andrewid",    limit: 255
    t.string   "dorm",        limit: 255
    t.string   "room",        limit: 255
    t.string   "cell_number", limit: 255
    t.integer  "partner_id",  limit: 4
    t.string   "title",       limit: 255
    t.boolean  "admin",       limit: 1
    t.boolean  "staff",       limit: 1
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "program_id",  limit: 4
    t.date     "arrives_on"
    t.date     "departs_on"
  end

  add_index "users", ["partner_id"], name: "index_users_on_partner_id", using: :btree
  add_index "users", ["program_id"], name: "index_users_on_program_id", using: :btree

  add_foreign_key "checkin_sessions", "checkin_session_types"
  add_foreign_key "checkin_users", "checkin_sessions"
  add_foreign_key "checkin_users", "users"
  add_foreign_key "user_counselors", "users"
  add_foreign_key "users", "programs"
end
