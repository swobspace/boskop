require 'rails_helper'

RSpec.describe "mac_prefixes/new", type: :view do
  before(:each) do
    assign(:mac_prefix, MacPrefix.new(
      :oui => "MyString",
      :vendor => "MyString"
    ))
  end

  it "renders new mac_prefix form" do
    render

    assert_select "form[action=?][method=?]", mac_prefixes_path, "post" do

      assert_select "input[name=?]", "mac_prefix[oui]"

      assert_select "input[name=?]", "mac_prefix[vendor]"
    end
  end
end
