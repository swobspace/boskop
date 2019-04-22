require 'rails_helper'

RSpec.describe "network_interfaces/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "network_interfaces" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:network_interfaces, FactoryBot.create_list(:network_interface, 2))
  end

  it "renders a list of network_interfaces" do
    pending "doesn't make much sense with 10.000+ hosts, needs datatable implementation"
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Mac".to_s, :count => 2
    assert_select "tr>td", :text => "Oui Vendor".to_s, :count => 2
  end
end
