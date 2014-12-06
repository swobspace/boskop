require 'rails_helper'

RSpec.describe "networks/index", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "networks" }
    allow(controller).to receive(:action_name) { "index" }

    location = FactoryGirl.create(:location, name: 'Lokation')

    assign(:networks, [
      Network.create!(
        :location => location,
        :netzwerk => "192.0.2.0/24",
        :name => "Name",
        :description => "MyText"
      ),
      Network.create!(
        :location => location,
        :netzwerk => "192.0.2.0/24",
        :name => "Name",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of networks" do
    render
    assert_select "tr>td", :text => "Lokation".to_s, :count => 2
    assert_select "tr>td", :text => "192.0.2.0/24".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
