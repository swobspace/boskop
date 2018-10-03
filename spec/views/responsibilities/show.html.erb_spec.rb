require 'rails_helper'

RSpec.describe "responsibilities/show", type: :view do
  before(:each) do
    @responsibility = assign(:responsibility, Responsibility.create!(
      :responsibility_for => nil,
      :contact => nil,
      :role => "Role",
      :title => "Title",
      :position => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Role/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/2/)
  end
end
