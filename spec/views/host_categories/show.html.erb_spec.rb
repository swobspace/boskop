require 'rails_helper'

RSpec.describe "host_categories/show", type: :view do
  before(:each) do
    @host_category = assign(:host_category, HostCategory.create!(
      :name => "Name",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
  end
end
