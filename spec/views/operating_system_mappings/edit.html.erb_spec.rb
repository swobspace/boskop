require 'rails_helper'

RSpec.describe "operating_system_mappings/edit", type: :view do
  before(:each) do
    @operating_system_mapping = assign(:operating_system_mapping, OperatingSystemMapping.create!(
      :field => "MyString",
      :value => "MyString",
      :operating_system => nil
    ))
  end

  it "renders the edit operating_system_mapping form" do
    render

    assert_select "form[action=?][method=?]", operating_system_mapping_path(@operating_system_mapping), "post" do

      assert_select "input[name=?]", "operating_system_mapping[field]"

      assert_select "input[name=?]", "operating_system_mapping[value]"

      assert_select "input[name=?]", "operating_system_mapping[operating_system_id]"
    end
  end
end
