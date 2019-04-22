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

ActiveRecord::Schema.define(version: 2019_04_22_090831) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "addresses", force: :cascade do |t|
    t.string "addressfor_type"
    t.bigint "addressfor_id"
    t.string "streetaddress", default: ""
    t.string "plz", default: ""
    t.string "ort", default: ""
    t.string "care_of", default: ""
    t.string "postfach", default: ""
    t.string "postfachplz", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressfor_type", "addressfor_id"], name: "index_addresses_on_addressfor_type_and_addressfor_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "sn", default: "", null: false
    t.string "givenname", default: "", null: false
    t.string "displayname", default: ""
    t.string "title", default: ""
    t.string "anrede", default: ""
    t.string "position", default: ""
    t.string "streetaddress", default: ""
    t.string "plz", default: ""
    t.string "ort", default: ""
    t.string "postfach", default: ""
    t.string "postfachplz", default: ""
    t.string "care_of", default: ""
    t.string "telephone", default: ""
    t.string "telefax", default: ""
    t.string "mobile", default: ""
    t.string "mail", default: ""
    t.string "internet", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "framework_contracts", force: :cascade do |t|
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
    t.string "tag", default: ""
  end

  create_table "hosts", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: ""
    t.string "cpe", default: ""
    t.string "raw_os", default: ""
    t.bigint "operating_system_id"
    t.date "lastseen"
    t.bigint "host_category_id"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fqdn", default: ""
    t.string "workgroup", default: ""
    t.string "domain_dns", default: ""
    t.string "vendor"
    t.string "vuln_risk", default: ""
    t.string "serial", default: ""
    t.string "uuid", default: ""
    t.string "product", default: ""
    t.string "warranty_sla", default: ""
    t.date "warranty_start"
    t.date "warranty_end"
    t.index ["cpe"], name: "index_hosts_on_cpe"
    t.index ["host_category_id"], name: "index_hosts_on_host_category_id"
    t.index ["location_id"], name: "index_hosts_on_location_id"
    t.index ["operating_system_id"], name: "index_hosts_on_operating_system_id"
    t.index ["raw_os"], name: "index_hosts_on_raw_os"
    t.index ["serial"], name: "index_hosts_on_serial"
    t.index ["uuid"], name: "index_hosts_on_uuid"
    t.index ["vuln_risk"], name: "index_hosts_on_vuln_risk"
  end

  create_table "line_states", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lines", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.string "provider_id", default: ""
    t.integer "location_a_id"
    t.integer "location_b_id"
    t.bigint "access_type_id"
    t.decimal "bw_upstream", precision: 10, scale: 1
    t.decimal "bw_downstream", precision: 10, scale: 1
    t.bigint "framework_contract_id"
    t.date "contract_start"
    t.date "contract_end"
    t.string "contract_period", default: ""
    t.integer "period_of_notice"
    t.string "period_of_notice_unit"
    t.integer "renewal_period"
    t.string "renewal_unit"
    t.bigint "line_state_id"
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

  create_table "locations", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: ""
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lid"
    t.boolean "disabled", default: false
    t.index ["ancestry"], name: "index_locations_on_ancestry"
    t.index ["disabled"], name: "index_locations_on_disabled"
    t.index ["lid"], name: "index_locations_on_lid"
    t.index ["name"], name: "index_locations_on_name"
  end

  create_table "mac_prefixes", force: :cascade do |t|
    t.string "oui", limit: 6, null: false
    t.string "vendor", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oui"], name: "index_mac_prefixes_on_oui"
  end

  create_table "merkmale", force: :cascade do |t|
    t.string "merkmalfor_type"
    t.bigint "merkmalfor_id"
    t.bigint "merkmalklasse_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merkmalfor_type", "merkmalfor_id"], name: "index_merkmale_on_merkmalfor_type_and_merkmalfor_id"
    t.index ["merkmalklasse_id"], name: "index_merkmale_on_merkmalklasse_id"
  end

  create_table "merkmalklassen", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: ""
    t.string "format", default: "", null: false
    t.text "possible_values"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "mandantory", default: false
    t.boolean "unique", default: false
    t.integer "position", default: 0
    t.string "for_object", default: "", null: false
    t.string "visible"
    t.string "baselink", default: ""
    t.string "tag", default: ""
    t.index ["for_object"], name: "index_merkmalklassen_on_for_object"
    t.index ["name"], name: "index_merkmalklassen_on_name"
  end

  create_table "nessus_scans", force: :cascade do |t|
    t.string "nessus_id", default: ""
    t.string "uuid", default: ""
    t.string "name", default: ""
    t.string "status", default: ""
    t.date "last_modification_date"
    t.string "import_state", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "import_mode", default: ""
    t.index ["nessus_id"], name: "index_nessus_scans_on_nessus_id"
    t.index ["uuid"], name: "index_nessus_scans_on_uuid"
  end

  create_table "network_interfaces", force: :cascade do |t|
    t.bigint "host_id"
    t.string "if_description", default: ""
    t.inet "ip"
    t.date "lastseen"
    t.string "mac", default: ""
    t.string "oui_vendor", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["host_id"], name: "index_network_interfaces_on_host_id"
  end

  create_table "networks", force: :cascade do |t|
    t.bigint "location_id"
    t.cidr "netzwerk"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_networks_on_location_id"
  end

  create_table "operating_system_mappings", force: :cascade do |t|
    t.string "field"
    t.string "value"
    t.bigint "operating_system_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["field"], name: "index_operating_system_mappings_on_field"
    t.index ["operating_system_id"], name: "index_operating_system_mappings_on_operating_system_id"
    t.index ["value"], name: "index_operating_system_mappings_on_value"
  end

  create_table "operating_systems", force: :cascade do |t|
    t.string "name"
    t.text "matching_pattern"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "eol"
  end

  create_table "org_units", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "description", default: ""
    t.string "ancestry"
    t.integer "ancestry_depth", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_org_units_on_ancestry"
    t.index ["name"], name: "index_org_units_on_name"
  end

  create_table "responsibilities", force: :cascade do |t|
    t.string "responsibility_for_type"
    t.bigint "responsibility_for_id"
    t.bigint "contact_id"
    t.string "role", default: ""
    t.string "title", default: ""
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_responsibilities_on_contact_id"
    t.index ["responsibility_for_type", "responsibility_for_id"], name: "index_responsibility_for"
    t.index ["role"], name: "index_responsibilities_on_role"
  end

  create_table "vulnerabilities", force: :cascade do |t|
    t.bigint "host_id"
    t.bigint "vulnerability_detail_id"
    t.date "lastseen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "plugin_output"
    t.index ["host_id"], name: "index_vulnerabilities_on_host_id"
    t.index ["vulnerability_detail_id"], name: "index_vulnerabilities_on_vulnerability_detail_id"
  end

  create_table "vulnerability_details", force: :cascade do |t|
    t.string "name", default: ""
    t.string "nvt", default: ""
    t.string "family", default: ""
    t.string "threat", default: ""
    t.decimal "severity", default: "0.0"
    t.string "cves", default: [], array: true
    t.string "bids", default: [], array: true
    t.string "xrefs", default: [], array: true
    t.jsonb "notes", default: {}
    t.jsonb "certs", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family"], name: "index_vulnerability_details_on_family"
    t.index ["nvt"], name: "index_vulnerability_details_on_nvt"
    t.index ["threat"], name: "index_vulnerability_details_on_threat"
  end

  create_table "wobauth_authorities", force: :cascade do |t|
    t.bigint "authorizable_id"
    t.string "authorizable_type"
    t.bigint "role_id"
    t.bigint "authorized_for_id"
    t.string "authorized_for_type"
    t.date "valid_from"
    t.date "valid_until"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["authorizable_id"], name: "index_wobauth_authorities_on_authorizable_id"
    t.index ["authorized_for_id"], name: "index_wobauth_authorities_on_authorized_for_id"
    t.index ["role_id"], name: "index_wobauth_authorities_on_role_id"
  end

  create_table "wobauth_groups", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wobauth_memberships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.boolean "auto", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_wobauth_memberships_on_group_id"
    t.index ["user_id"], name: "index_wobauth_memberships_on_user_id"
  end

  create_table "wobauth_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wobauth_users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.text "gruppen"
    t.string "sn"
    t.string "givenname"
    t.string "displayname"
    t.string "telephone"
    t.string "active_directory_guid"
    t.string "userprincipalname"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", default: ""
    t.string "position", default: ""
    t.string "department", default: ""
    t.string "company", default: ""
    t.index ["reset_password_token"], name: "index_wobauth_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_wobauth_users_on_username", unique: true
  end

end
