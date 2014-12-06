require 'rails_helper'

RSpec.describe "networks/new", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "networks" }
    allow(controller).to receive(:action_name) { "new" }

    location = FactoryGirl.create(:location)

    assign(:network, Network.new(
      :location => location,
      :netzwerk => "192.0.2.0/24",
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new network form" do
    render

    assert_select "form[action=?][method=?]", networks_path, "post" do
      assert_select "select#network_location_id[name=?]", "network[location_id]"
      assert_select "input#network_netzwerk[name=?]", "network[netzwerk]"
      assert_select "input#network_name[name=?]", "network[name]"
      assert_select "textarea#network_description[name=?]", "network[description]"
    end
  end
end
