require 'rails_helper'

RSpec.describe "locations/show", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "locations" }
    allow(controller).to receive(:action_name) { "show" }

    @location = assign(:location, Location.create!(
      :name => "Name",
      :description => "Description",
      :position => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/2/)
  end
end
