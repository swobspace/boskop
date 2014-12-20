require 'rails_helper'

RSpec.describe "networks/edit", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "networks" }
    allow(controller).to receive(:action_name) { "edit" }

    location = FactoryGirl.create(:location)

    @network = assign(:network, Network.create!(
      :location => location,
      :netzwerk => "192.0.2.0/24",
      :description => "MyText"
    ))
  end

  it "renders the edit network form" do
    render

    assert_select "form[action=?][method=?]", network_path(@network), "post" do

      assert_select "select#network_location_id[name=?]", "network[location_id]"
      assert_select "input#network_netzwerk[name=?]", "network[netzwerk]"
      assert_select "textarea#network_description[name=?]", "network[description]"
    end
  end
end
