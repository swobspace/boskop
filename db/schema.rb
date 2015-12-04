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

ActiveRecord::Schema.define(version: 20151204094204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_types", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.integer  "addressfor_id"
    t.string   "addressfor_type", limit: 255
    t.string   "streetaddress",   limit: 255, default: ""
    t.string   "plz",             limit: 255, default: ""
    t.string   "ort",             limit: 255, default: ""
    t.string   "care_of",         limit: 255, default: ""
    t.string   "postfach",        limit: 255, default: ""
    t.string   "postfachplz",     limit: 255, default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressfor_id", "addressfor_type"], name: "index_addresses_on_addressfor_id_and_addressfor_type", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "description",    limit: 255, default: ""
    t.string   "ancestry",       limit: 255
    t.integer  "ancestry_depth",             default: 0,  null: false
    t.integer  "position",                   default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lid",            limit: 255
    t.string   "name",           limit: 255
  end

  add_index "locations", ["ancestry"], name: "index_locations_on_ancestry", using: :btree
  add_index "locations", ["lid"], name: "index_locations_on_lid", using: :btree

  create_table "merkmale", force: :cascade do |t|
    t.integer  "merkmalfor_id"
    t.string   "merkmalfor_type",  limit: 255
    t.integer  "merkmalklasse_id"
    t.string   "value",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "merkmale", ["merkmalfor_id", "merkmalfor_type"], name: "index_merkmale_on_merkmalfor_id_and_merkmalfor_type", using: :btree
  add_index "merkmale", ["merkmalklasse_id"], name: "index_merkmale_on_merkmalklasse_id", using: :btree

  create_table "merkmalklassen", force: :cascade do |t|
    t.string   "name",            limit: 255, default: "",    null: false
    t.text     "description",                 default: ""
    t.string   "format",          limit: 255, default: "",    null: false
    t.text     "possible_values"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "mandantory",                  default: false
    t.boolean  "unique",                      default: false
    t.integer  "position",                    default: 0
    t.string   "for_object",      limit: 255, default: "",    null: false
    t.string   "visible",         limit: 255
    t.string   "baselink",        limit: 255, default: ""
  end

  add_index "merkmalklassen", ["for_object"], name: "index_merkmalklassen_on_for_object", using: :btree
  add_index "merkmalklassen", ["name"], name: "index_merkmalklassen_on_name", using: :btree

  create_table "networks", force: :cascade do |t|
    t.integer  "location_id"
    t.cidr     "netzwerk"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "networks", ["location_id"], name: "index_networks_on_location_id", using: :btree

  create_table "org_units", force: :cascade do |t|
    t.string   "name",           limit: 255, default: "", null: false
    t.string   "description",    limit: 255, default: ""
    t.string   "ancestry",       limit: 255
    t.integer  "ancestry_depth",             default: 0,  null: false
    t.integer  "position",                   default: 0,  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "org_units", ["ancestry"], name: "index_org_units_on_ancestry", using: :btree
  add_index "org_units", ["name"], name: "index_org_units_on_name", using: :btree

  create_table "wobauth_authorities", force: :cascade do |t|
    t.integer  "authorizable_id"
    t.string   "authorizable_type",   limit: 255
    t.integer  "role_id"
    t.integer  "authorized_for_id"
    t.string   "authorized_for_type", limit: 255
    t.date     "valid_from"
    t.date     "valid_until"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wobauth_authorities", ["authorizable_id"], name: "index_wobauth_authorities_on_authorizable_id", using: :btree
  add_index "wobauth_authorities", ["authorized_for_id"], name: "index_wobauth_authorities_on_authorized_for_id", using: :btree
  add_index "wobauth_authorities", ["role_id"], name: "index_wobauth_authorities_on_role_id", using: :btree

  create_table "wobauth_groups", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wobauth_memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.boolean  "auto",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wobauth_memberships", ["group_id"], name: "index_wobauth_memberships_on_group_id", using: :btree
  add_index "wobauth_memberships", ["user_id"], name: "index_wobauth_memberships_on_user_id", using: :btree

  create_table "wobauth_roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wobauth_users", force: :cascade do |t|
    t.string   "username",               limit: 255, default: "", null: false
    t.text     "gruppen"
    t.string   "sn",                     limit: 255
    t.string   "givenname",              limit: 255
    t.string   "displayname",            limit: 255
    t.string   "telephone",              limit: 255
    t.string   "active_directory_guid",  limit: 255
    t.string   "userprincipalname",      limit: 255
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wobauth_users", ["reset_password_token"], name: "index_wobauth_users_on_reset_password_token", unique: true, using: :btree
  add_index "wobauth_users", ["username"], name: "index_wobauth_users_on_username", unique: true, using: :btree

end
