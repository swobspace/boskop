require 'rails_helper'

RSpec.describe "host_categories/new", type: :view do
  before(:each) do
    assign(:host_category, HostCategory.new(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders new host_category form" do
    render

    assert_select "form[action=?][method=?]", host_categories_path, "post" do

      assert_select "input[name=?]", "host_category[name]"

      assert_select "textarea[name=?]", "host_category[description]"
    end
  end
end
