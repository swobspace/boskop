require 'rails_helper'

RSpec.describe "networks/show", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "networks" }
    allow(controller).to receive(:action_name) { "edit" }

    location = FactoryGirl.create(:location, name: "Lokation")

    @network = assign(:network, Network.create!(
      :location => location,
      :netzwerk => "192.0.2.0/24",
      :name => "Name",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Lokation/)
    expect(rendered).to match(/192.0.2.0\/24/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
