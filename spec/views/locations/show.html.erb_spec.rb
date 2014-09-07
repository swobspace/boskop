require 'rails_helper'

RSpec.describe "locations/show", :type => :view do
  before(:each) do
    @location = assign(:location, Location.create!(
      :name => "Name",
      :description => "Description",
      :ancestry => "Ancestry",
      :ancestry_depth => 1,
      :position => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Description/)
    expect(rendered).to match(/Ancestry/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
  end
end
