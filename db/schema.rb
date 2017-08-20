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

ActiveRecord::Schema.define(version: 20170820093009) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_types", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.integer "addressfor_id"
    t.string "addressfor_type", limit: 255
    t.string "streetaddress", limit: 255, default: ""
    t.string "plz", limit: 255, default: ""
    t.string "ort", limit: 255, default: ""
    t.string "care_of", limit: 255, default: ""
    t.string "postfach", limit: 255, default: ""
    t.string "postfachplz", limit: 255, default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["addressfor_id", "addressfor_type"], name: "index_addresses_on_addressfor_id_and_addressfor_type"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "framework_contracts", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.date "contract_start"
    t.date "contract_end"
    t.string "contract_period", default: ""
    t.integer "period_of_notice"
    t.string "period_of_notice_unit"
    t.integer "renewal_period"
    t.string "renewal_unit"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "host_categories", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hosts", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: ""
    t.cidr "ip"
    t.string "cpe", default: ""
    t.string "lanmanager", default: ""
    t.bigint "operating_system_id"
    t.date "lastseen"
    t.string "mac", default: ""
    t.bigint "host_category_id"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpe"], name: "index_hosts_on_cpe"
    t.index ["host_category_id"], name: "index_hosts_on_host_category_id"
    t.index ["lanmanager"], name: "index_hosts_on_lanmanager"
    t.index ["location_id"], name: "index_hosts_on_location_id"
    t.index ["operating_system_id"], name: "index_hosts_on_operating_system_id"
  end

  create_table "line_states", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lines", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.string "provider_id", default: ""
    t.integer "location_a_id"
    t.integer "location_b_id"
    t.integer "access_type_id"
    t.decimal "bw_upstream", precision: 10, scale: 1
    t.decimal "bw_downstream", precision: 10, scale: 1
    t.integer "framework_contract_id"
    t.date "contract_start"
    t.date "contract_end"
    t.string "contract_period", default: ""
    t.integer "period_of_notice"
    t.string "period_of_notice_unit"
    t.integer "renewal_period"
    t.string "renewal_unit"
    t.integer "line_state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "bw2_upstream", precision: 10, scale: 1
    t.decimal "bw2_downstream", precision: 10, scale: 1
    t.text "notes", default: ""
    t.index ["access_type_id"], name: "index_lines_on_access_type_id"
    t.index ["framework_contract_id"], name: "index_lines_on_framework_contract_id"
    t.index ["line_state_id"], name: "index_lines_on_line_state_id"
    t.index ["location_a_id"], name: "index_lines_on_location_a_id"
    t.index ["location_b_id"], name: "index_lines_on_location_b_id"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "description", limit: 255, default: ""
    t.string "ancestry", limit: 255
    t.integer "ancestry_depth", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "lid", limit: 255
    t.index ["ancestry"], name: "index_locations_on_ancestry"
    t.index ["lid"], name: "index_locations_on_lid"
    t.index ["name"], name: "index_locations_on_name"
  end

  create_table "merkmale", id: :serial, force: :cascade do |t|
    t.integer "merkmalfor_id"
    t.string "merkmalfor_type", limit: 255
    t.integer "merkmalklasse_id"
    t.string "value", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["merkmalfor_id", "merkmalfor_type"], name: "index_merkmale_on_merkmalfor_id_and_merkmalfor_type"
    t.index ["merkmalklasse_id"], name: "index_merkmale_on_merkmalklasse_id"
  end

  create_table "merkmalklassen", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.text "description", default: ""
    t.string "format", limit: 255, default: "", null: false
    t.text "possible_values"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "mandantory", default: false
    t.boolean "unique", default: false
    t.integer "position", default: 0
    t.string "for_object", limit: 255, default: "", null: false
    t.string "visible", limit: 255
    t.string "baselink", limit: 255, default: ""
    t.index ["for_object"], name: "index_merkmalklassen_on_for_object"
    t.index ["name"], name: "index_merkmalklassen_on_name"
  end

  create_table "networks", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.cidr "netzwerk"
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["location_id"], name: "index_networks_on_location_id"
  end

  create_table "org_units", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: "", null: false
    t.string "description", limit: 255, default: ""
    t.string "ancestry", limit: 255
    t.integer "ancestry_depth", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["ancestry"], name: "index_org_units_on_ancestry"
    t.index ["name"], name: "index_org_units_on_name"
  end

  create_table "wobauth_authorities", id: :serial, force: :cascade do |t|
    t.integer "authorizable_id"
    t.string "authorizable_type", limit: 255
    t.integer "role_id"
    t.integer "authorized_for_id"
    t.string "authorized_for_type", limit: 255
    t.date "valid_from"
    t.date "valid_until"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["authorizable_id"], name: "index_wobauth_authorities_on_authorizable_id"
    t.index ["authorized_for_id"], name: "index_wobauth_authorities_on_authorized_for_id"
    t.index ["role_id"], name: "index_wobauth_authorities_on_role_id"
  end

  create_table "wobauth_groups", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wobauth_memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "auto", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["group_id"], name: "index_wobauth_memberships_on_group_id"
    t.index ["user_id"], name: "index_wobauth_memberships_on_user_id"
  end

  create_table "wobauth_roles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wobauth_users", id: :serial, force: :cascade do |t|
    t.string "username", limit: 255, default: "", null: false
    t.text "gruppen"
    t.string "sn", limit: 255
    t.string "givenname", limit: 255
    t.string "displayname", limit: 255
    t.string "telephone", limit: 255
    t.string "active_directory_guid", limit: 255
    t.string "userprincipalname", limit: 255
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["reset_password_token"], name: "index_wobauth_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_wobauth_users_on_username", unique: true
  end

end
