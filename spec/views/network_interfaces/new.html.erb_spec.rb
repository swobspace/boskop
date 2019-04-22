require 'rails_helper'

RSpec.describe "network_interfaces/new", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "network_interfaces" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:network_interface, FactoryBot.build(:network_interface))
  end

  it "renders new network_interface form" do
    render

    assert_select "form[action=?][method=?]", network_interfaces_path, "post" do
      assert_select "select[name=?]", "network_interface[host_id]"
      assert_select "input[name=?]", "network_interface[if_description]"
      assert_select "input[name=?]", "network_interface[ip]"
      assert_select "input[name=?]", "network_interface[mac]"
      assert_select "input[name=?]", "network_interface[oui_vendor]"
    end
  end
end
