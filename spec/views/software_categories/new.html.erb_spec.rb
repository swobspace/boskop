require 'rails_helper'

RSpec.describe "software_categories/new", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software_categories" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:software_category, SoftwareCategory.new(
      name: "MyString",
      description: "MyText",
      main_business_process: "MyText"
    ))
  end

  it "renders new software_category form" do
    render

    assert_select "form[action=?][method=?]", software_categories_path, "post" do

      assert_select "input[name=?]", "software_category[name]"

      assert_select "textarea[name=?]", "software_category[description]"

      assert_select "textarea[name=?]", "software_category[main_business_process]"
    end
  end
end
