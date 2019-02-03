require 'rails_helper'

RSpec.describe "mac_prefixes/edit", type: :view do
  before(:each) do
    @mac_prefix = assign(:mac_prefix, MacPrefix.create!(
      :oui => "MyString",
      :vendor => "MyString"
    ))
  end

  it "renders the edit mac_prefix form" do
    render

    assert_select "form[action=?][method=?]", mac_prefix_path(@mac_prefix), "post" do

      assert_select "input[name=?]", "mac_prefix[oui]"

      assert_select "input[name=?]", "mac_prefix[vendor]"
    end
  end
end
