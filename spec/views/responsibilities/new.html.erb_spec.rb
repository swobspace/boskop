require 'rails_helper'

RSpec.describe "responsibilities/new", type: :view do
  before(:each) do
    assign(:responsibility, Responsibility.new(
      :responsibility_for => nil,
      :contact => nil,
      :role => "MyString",
      :title => "MyString",
      :position => 1
    ))
  end

  it "renders new responsibility form" do
    render

    assert_select "form[action=?][method=?]", responsibilities_path, "post" do

      assert_select "input[name=?]", "responsibility[responsibility_for_id]"

      assert_select "input[name=?]", "responsibility[contact_id]"

      assert_select "input[name=?]", "responsibility[role]"

      assert_select "input[name=?]", "responsibility[title]"

      assert_select "input[name=?]", "responsibility[position]"
    end
  end
end
