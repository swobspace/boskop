require 'rails_helper'

RSpec.describe "hosts/search_form", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "hosts" }
    allow(controller).to receive(:action_name) { "search_form" }

    @ability.can :csv, Host
  end

  it "renders search host form" do
    render

    assert_select "form[action=?][method=?]", search_hosts_path, "post" do
      assert_select "input[name=?]", "name"
      assert_select "input[name=?]", "description"
      assert_select "input[name=?]", "ip"
      assert_select "input[name=?]", "operating_system"
      assert_select "input[name=?]", "cpe"
      assert_select "input[name=?]", "raw_os"
      assert_select "input[name=?]", "mac"
      assert_select "input[name=?]", "serial"
      assert_select "input[name=?]", "uuid"
      assert_select "input[name=?]", "fqdn"
      assert_select "input[name=?]", "domain_dns"
      assert_select "input[name=?]", "workgroup"
      assert_select "input[name=?]", "vendor"
      assert_select "input[name=?]", "product"
      assert_select "input[name=?]", "warranty_start_from"
      assert_select "input[name=?]", "warranty_start_until"
      assert_select "input[name=?]", "newer"
      assert_select "input[name=?]", "older"
      assert_select "input[name=?]", "created_at"
      assert_select "input[name=?]", "host_category"
      assert_select "select[name=?]", "lid[]"
      assert_select "input[name=?]", "limit"
      assert_select "input[name=?]", "current"
      assert_select "input[name=?]", "eol"
      assert_select "input[name=?]", "vuln_risk"
      assert_select "input[name=?]", "commit", count: 2
    end
  end
end
