require 'rails_helper'

RSpec.describe "responsibilities/edit", type: :view do
  before(:each) do
    @responsibility = assign(:responsibility, Responsibility.create!(
      :responsibility_for => nil,
      :contact => nil,
      :role => "MyString",
      :title => "MyString",
      :position => 1
    ))
  end

  it "renders the edit responsibility form" do
    render

    assert_select "form[action=?][method=?]", responsibility_path(@responsibility), "post" do

      assert_select "input[name=?]", "responsibility[responsibility_for_id]"

      assert_select "input[name=?]", "responsibility[contact_id]"

      assert_select "input[name=?]", "responsibility[role]"

      assert_select "input[name=?]", "responsibility[title]"

      assert_select "input[name=?]", "responsibility[position]"
    end
  end
end
