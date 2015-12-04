require 'rails_helper'

RSpec.describe "line_states/show", type: :view do
  before(:each) do
    @line_state = assign(:line_state, LineState.create!(
      :name => "Name",
      :description => "MyText",
      :active => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
  end
end
