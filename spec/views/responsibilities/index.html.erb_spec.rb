require 'rails_helper'

RSpec.describe "responsibilities/index", type: :view do
  before(:each) do
    assign(:responsibilities, [
      Responsibility.create!(
        :responsibility_for => nil,
        :contact => nil,
        :role => "Role",
        :title => "Title",
        :position => 2
      ),
      Responsibility.create!(
        :responsibility_for => nil,
        :contact => nil,
        :role => "Role",
        :title => "Title",
        :position => 2
      )
    ])
  end

  it "renders a list of responsibilities" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Role".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
