require 'rails_helper'

RSpec.describe "software/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software" }
    allow(controller).to receive(:action_name) { "edit" }

    @software = assign(:software, Software.create!(
      name: "MyString",
      pattern: "MyText",
      vendor: "MyString",
      description: "MyText",
      minimum_allowed_version: "MyString",
      maximum_allowed_version: "MyString",
      software_category: nil
    ))
  end

  it "renders the edit software form" do
    render

    assert_select "form[action=?][method=?]", software_path(@software), "post" do

      assert_select "input[name=?]", "software[name]"

      assert_select "textarea[name=?]", "software[pattern]"

      assert_select "input[name=?]", "software[vendor]"

      assert_select "textarea[name=?]", "software[description]"

      assert_select "input[name=?]", "software[minimum_allowed_version]"

      assert_select "input[name=?]", "software[maximum_allowed_version]"

      assert_select "select[name=?]", "software[software_category_id]"

      assert_select "input[name=?]", "software[green]"
      assert_select "input[name=?]", "software[yellow]"
      assert_select "input[name=?]", "software[red]"
    end
  end
end
