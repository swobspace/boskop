require 'rails_helper'

RSpec.describe "hosts/new", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "hosts" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:host, FactoryGirl.build(:host))
  end

  it "renders new host form" do
    render

    assert_select "form[action=?][method=?]", hosts_path, "post" do

      assert_select "input[name=?]", "host[name]"

      assert_select "textarea[name=?]", "host[description]"

      assert_select "input[name=?]", "host[ip]"

      assert_select "input[name=?]", "host[cpe]"

      assert_select "input[name=?]", "host[lanmanager]"

      assert_select "input[name=?]", "host[mac]"

      assert_select "select[name=?]", "host[host_category_id]"

      assert_select "select[name=?]", "host[location_id]"
    end
  end
end
