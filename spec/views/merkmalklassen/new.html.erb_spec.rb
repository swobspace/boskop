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
      :visible => ['index'],
      :for_object => 'OrgUnit',
      :possible_values => ["MyText"]
    ))
  end

  it "renders new merkmalklasse form" do
    render

    assert_select "form[action=?][method=?]", merkmalklassen_path, "post" do

      assert_select "input#merkmalklasse_name[name=?]", "merkmalklasse[name]"
      assert_select "input#merkmalklasse_tag[name=?]", "merkmalklasse[tag]"

      assert_select "textarea#merkmalklasse_description[name=?]", "merkmalklasse[description]"

      assert_select "select#merkmalklasse_format[name=?]", "merkmalklasse[format]"
      assert_select "select#merkmalklasse_for_object[name=?]", "merkmalklasse[for_object]"
      assert_select "input#merkmalklasse_mandantory[name=?]", "merkmalklasse[mandantory]"
      assert_select "input#merkmalklasse_unique[name=?]", "merkmalklasse[unique]"
      assert_select "input#merkmalklasse_position[name=?]", "merkmalklasse[position]"
      assert_select "select#merkmalklasse_visible[name=?]", "merkmalklasse[visible][]"
      assert_select "input#merkmalklasse_pvalues[name=?]", "merkmalklasse[pvalues]"
    end
  end
end
