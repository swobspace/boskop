require 'rails_helper'

RSpec.describe "vulnerabilities/search_form", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "vulnerabilities" }
    allow(controller).to receive(:action_name) { "search_form" }
  end

  it "renders search host form" do
    render

    assert_select "form[action=?][method=?]", search_vulnerabilities_path, "post" do
      assert_select "input[name=?]", "name"
      assert_select "select[name=?]", "threats[]"
      assert_select "input[name=?]", "severity"
      assert_select "input[name=?]", "ip"
      assert_select "input[name=?]", "hostname"
      assert_select "input[name=?]", "host_category"
      assert_select "input[name=?]", "operating_system"
      assert_select "input[name=?]", "plugin_output"
      assert_select "input[name=?]", "newer"
      assert_select "input[name=?]", "older"
      assert_select "input[name=?]", "created_newer"
      assert_select "input[name=?]", "created_older"
      assert_select "select[name=?]", "lid[]"
      assert_select "input[name=?]", "limit"
    end
  end
end
