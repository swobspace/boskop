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

ActiveRecord::Schema.define(version: 20140906153541) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "merkmalklassen", force: true do |t|
    t.string   "name",            default: "",    null: false
    t.text     "description",     default: ""
    t.string   "format",          default: "",    null: false
    t.text     "possible_values"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mandantory",      default: false
    t.boolean  "unique",          default: false
    t.integer  "position",        default: 0
    t.string   "for_object",      default: "",    null: false
  end

  add_index "merkmalklassen", ["for_object"], name: "index_merkmalklassen_on_for_object", using: :btree
  add_index "merkmalklassen", ["name"], name: "index_merkmalklassen_on_name", using: :btree

  create_table "wobauth_authorities", force: true do |t|
    t.integer  "authorizable_id"
    t.string   "authorizable_type"
    t.integer  "role_id"
    t.integer  "authorized_for_id"
    t.string   "authorized_for_type"
    t.date     "valid_from"
    t.date     "valid_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wobauth_authorities", ["authorizable_id"], name: "index_wobauth_authorities_on_authorizable_id", using: :btree
  add_index "wobauth_authorities", ["authorized_for_id"], name: "index_wobauth_authorities_on_authorized_for_id", using: :btree
  add_index "wobauth_authorities", ["role_id"], name: "index_wobauth_authorities_on_role_id", using: :btree

  create_table "wobauth_groups", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wobauth_memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "auto",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wobauth_memberships", ["group_id"], name: "index_wobauth_memberships_on_group_id", using: :btree
  add_index "wobauth_memberships", ["user_id"], name: "index_wobauth_memberships_on_user_id", using: :btree

  create_table "wobauth_roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wobauth_users", force: true do |t|
    t.string   "username",               default: "", null: false
    t.text     "gruppen"
    t.string   "sn"
    t.string   "givenname"
    t.string   "displayname"
    t.string   "telephone"
    t.string   "active_directory_guid"
    t.string   "userprincipalname"
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

  add_index "wobauth_users", ["reset_password_token"], name: "index_wobauth_users_on_reset_password_token", unique: true, using: :btree
  add_index "wobauth_users", ["username"], name: "index_wobauth_users_on_username", unique: true, using: :btree

end
