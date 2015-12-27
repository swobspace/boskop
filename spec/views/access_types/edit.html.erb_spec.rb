require 'rails_helper'

RSpec.describe "access_types/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "access_types" }
    allow(controller).to receive(:action_name) { "edit" }

    @access_type = assign(:access_type, AccessType.create!(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit access_type form" do
    render

    assert_select "form[action=?][method=?]", access_type_path(@access_type), "post" do

      assert_select "input#access_type_name[name=?]", "access_type[name]"

      assert_select "textarea#access_type_description[name=?]", "access_type[description]"
    end
  end
end
