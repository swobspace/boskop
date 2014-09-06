require 'rails_helper'

RSpec.describe "merkmalklassen/new", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "sites" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:merkmalklasse, Merkmalklasse.new(
      :name => "MyString",
      :description => "MyText",
      :format => "string",
      :possible_values => "MyText"
    ))
  end

  it "renders new merkmalklasse form" do
    render

    assert_select "form[action=?][method=?]", merkmalklassen_path, "post" do

      assert_select "input#merkmalklasse_name[name=?]", "merkmalklasse[name]"

      assert_select "textarea#merkmalklasse_description[name=?]", "merkmalklasse[description]"

      assert_select "select#merkmalklasse_format[name=?]", "merkmalklasse[format]"

      assert_select "textarea#merkmalklasse_possible_values[name=?]", "merkmalklasse[possible_values]"
    end
  end
end
