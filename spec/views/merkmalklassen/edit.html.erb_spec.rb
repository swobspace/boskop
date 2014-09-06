require 'rails_helper'

RSpec.describe "merkmalklassen/edit", :type => :view do
  before(:each) do
    @merkmalklasse = assign(:merkmalklasse, Merkmalklasse.create!(
      :name => "MyString",
      :description => "MyText",
      :format => "MyString",
      :possible_values => "MyText"
    ))
  end

  it "renders the edit merkmalklasse form" do
    render

    assert_select "form[action=?][method=?]", merkmalklasse_path(@merkmalklasse), "post" do

      assert_select "input#merkmalklasse_name[name=?]", "merkmalklasse[name]"

      assert_select "textarea#merkmalklasse_description[name=?]", "merkmalklasse[description]"

      assert_select "input#merkmalklasse_format[name=?]", "merkmalklasse[format]"

      assert_select "textarea#merkmalklasse_possible_values[name=?]", "merkmalklasse[possible_values]"
    end
  end
end
