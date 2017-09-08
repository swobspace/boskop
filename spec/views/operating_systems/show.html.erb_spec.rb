require 'rails_helper'

RSpec.describe "operating_systems/show", type: :view do
  before(:each) do
    @operating_system = assign(:operating_system, OperatingSystem.create!(
      :name => "Name",
      :matching_pattern => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
