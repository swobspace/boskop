require 'rails_helper'

RSpec.describe "host_categories/edit", type: :view do
  before(:each) do
    @host_category = assign(:host_category, HostCategory.create!(
      :name => "MyString",
      :description => "MyText"
    ))
  end

  it "renders the edit host_category form" do
    render

    assert_select "form[action=?][method=?]", host_category_path(@host_category), "post" do

      assert_select "input[name=?]", "host_category[name]"

      assert_select "textarea[name=?]", "host_category[description]"
    end
  end
end
