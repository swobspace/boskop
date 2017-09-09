require 'rails_helper'

RSpec.describe "operating_system_mappings/show", type: :view do
  before(:each) do
    @operating_system_mapping = assign(:operating_system_mapping, OperatingSystemMapping.create!(
      :field => "Field",
      :value => "Value",
      :operating_system => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Field/)
    expect(rendered).to match(/Value/)
    expect(rendered).to match(//)
  end
end
