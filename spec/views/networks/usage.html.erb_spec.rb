require 'rails_helper'

RSpec.describe "networks/usage", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "networks" }
    allow(controller).to receive(:action_name) { "usage" }

    location = FactoryGirl.create(:location, name: 'Lokation', lid: 'LocID')
    net2 = FactoryGirl.create(:network,
        :location => location,
        :netzwerk => "192.0.2.0/24",
        :description => "MyDescription"
      )
    net3 = FactoryGirl.create(:network,
        :location => location,
        :netzwerk => "192.0.3.0/24",
        :description => "MyDescription"
      )

    @subnets = {
      '192.0.0.0/24' => [ ],
      '192.0.1.0/24' => [ ],
      '192.0.2.0/24' => [ net2 ],
      '192.0.3.0/24' => [ net3 ],
    }

    @merkmalklassen = []
  end

  it "renders a list of networks" do
    render
    assert_select "tr>td", :text => "Lokation".to_s, :count => 2
    assert_select "tr>td", :text => "LocID".to_s, :count => 2
    assert_select "tr>td", :text => "192.0.0.0/24".to_s, :count => 1
    assert_select "tr>td", :text => "192.0.1.0/24".to_s, :count => 1
    assert_select "tr>td", :text => "192.0.2.0/24".to_s, :count => 2
    assert_select "tr>td", :text => "192.0.3.0/24".to_s, :count => 2
    assert_select "tr>td", :text => "192.000.000.000".to_s, :count => 1
    assert_select "tr>td", :text => "192.000.001.000".to_s, :count => 1
    assert_select "tr>td", :text => "192.000.002.000".to_s, :count => 1
    assert_select "tr>td", :text => "192.000.003.000".to_s, :count => 1
    assert_select "tr>td", :text => "MyDescription".to_s, :count => 2
  end
end
