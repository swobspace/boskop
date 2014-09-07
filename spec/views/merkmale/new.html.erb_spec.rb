require 'rails_helper'

RSpec.describe "merkmale/new", :type => :view do
  before(:each) do
    assign(:merkmal, Merkmal.new(
      :merkmalfor => nil,
      :merkmalklasse => nil,
      :value => "MyString"
    ))
  end

  it "renders new merkmal form" do
    render

    assert_select "form[action=?][method=?]", merkmale_path, "post" do

      assert_select "input#merkmal_merkmalfor_id[name=?]", "merkmal[merkmalfor_id]"

      assert_select "input#merkmal_merkmalklasse_id[name=?]", "merkmal[merkmalklasse_id]"

      assert_select "input#merkmal_value[name=?]", "merkmal[value]"
    end
  end
end
