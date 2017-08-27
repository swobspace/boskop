require 'rails_helper'

RSpec.describe "hosts/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "hosts" }
    allow(controller).to receive(:action_name) { "edit" }

    @host = assign(:host, FactoryGirl.create(:host))
  end

  it "renders the edit host form" do
    render

    assert_select "form[action=?][method=?]", host_path(@host), "post" do

      assert_select "input[name=?]", "host[name]"

      assert_select "textarea[name=?]", "host[description]"

      assert_select "input[name=?]", "host[ip]"

      assert_select "input[name=?]", "host[cpe]"

      assert_select "input[name=?]", "host[raw_os]"

      assert_select "input[name=?]", "host[mac]"
      assert_select "input[name=?]", "host[fqdn]"
      assert_select "input[name=?]", "host[domain_dns]"
      assert_select "input[name=?]", "host[workgroup]"
      assert_select "input[name=?]", "host[vendor]"

      assert_select "select[name=?]", "host[host_category_id]"

      assert_select "select[name=?]", "host[location_id]"
    end
  end
end
