require 'rails_helper'

RSpec.describe "operating_system_mappings/index", type: :view do
  before(:each) do
    assign(:operating_system_mappings, [
      OperatingSystemMapping.create!(
        :field => "Field",
        :value => "Value",
        :operating_system => nil
      ),
      OperatingSystemMapping.create!(
        :field => "Field",
        :value => "Value",
        :operating_system => nil
      )
    ])
  end

  it "renders a list of operating_system_mappings" do
    render
    assert_select "tr>td", :text => "Field".to_s, :count => 2
    assert_select "tr>td", :text => "Value".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
