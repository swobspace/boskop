require 'rails_helper'

RSpec.describe "access_types/show", type: :view do
  before(:each) do
    @access_type = assign(:access_type, AccessType.create!(
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
