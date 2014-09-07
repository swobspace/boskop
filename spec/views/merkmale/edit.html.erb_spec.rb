require 'rails_helper'

RSpec.describe "merkmale/edit", :type => :view do
  before(:each) do
    @merkmal = assign(:merkmal, Merkmal.create!(
      :merkmalfor => nil,
      :merkmalklasse => nil,
      :value => "MyString"
    ))
  end

  it "renders the edit merkmal form" do
    render

    assert_select "form[action=?][method=?]", merkmal_path(@merkmal), "post" do

      assert_select "input#merkmal_merkmalfor_id[name=?]", "merkmal[merkmalfor_id]"

      assert_select "input#merkmal_merkmalklasse_id[name=?]", "merkmal[merkmalklasse_id]"

      assert_select "input#merkmal_value[name=?]", "merkmal[value]"
    end
  end
end
