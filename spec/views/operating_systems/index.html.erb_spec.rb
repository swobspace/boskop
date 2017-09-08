require 'rails_helper'

RSpec.describe "operating_systems/index", type: :view do
  before(:each) do
    assign(:operating_systems, [
      OperatingSystem.create!(
        :name => "Name",
        :matching_pattern => "MyText"
      ),
      OperatingSystem.create!(
        :name => "Name",
        :matching_pattern => "MyText"
      )
    ])
  end

  it "renders a list of operating_systems" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
