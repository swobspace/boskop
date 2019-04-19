require 'rails_helper'

RSpec.describe "network_interfaces/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "network_interfaces" }
    allow(controller).to receive(:action_name) { "edit" }

    @network_interface = assign(:network_interface, FactoryBot.create(:network_interface))
  end

  it "renders the edit network_interface form" do
    render

    assert_select "form[action=?][method=?]", network_interface_path(@network_interface), "post" do
      assert_select "select[name=?]", "network_interface[host_id]"
      assert_select "input[name=?]", "network_interface[description]"
      assert_select "input[name=?]", "network_interface[ip]"
      assert_select "input[name=?]", "network_interface[mac]"
      assert_select "input[name=?]", "network_interface[oui_vendor]"
    end
  end
end
