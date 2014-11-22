require 'rails_helper'

RSpec.describe "addresses/new", :type => :view do
  before(:each) do
    assign(:address, Address.new(
      :addressfor => nil,
      :streetaddress => "MyString",
      :plz => "MyString",
      :ort => "MyString",
      :care_of => "MyString",
      :postfach => "MyString",
      :postfachplz => "MyString"
    ))
  end

  it "renders new address form" do
    render

    assert_select "form[action=?][method=?]", addresses_path, "post" do

      assert_select "input#address_addressfor_id[name=?]", "address[addressfor_id]"

      assert_select "input#address_streetaddress[name=?]", "address[streetaddress]"

      assert_select "input#address_plz[name=?]", "address[plz]"

      assert_select "input#address_ort[name=?]", "address[ort]"

      assert_select "input#address_care_of[name=?]", "address[care_of]"

      assert_select "input#address_postfach[name=?]", "address[postfach]"

      assert_select "input#address_postfachplz[name=?]", "address[postfachplz]"
    end
  end
end
