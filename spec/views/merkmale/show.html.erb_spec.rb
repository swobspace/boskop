require 'rails_helper'

RSpec.describe "merkmale/show", :type => :view do
  before(:each) do
    @merkmal = assign(:merkmal, Merkmal.create!(
      :merkmalfor => nil,
      :merkmalklasse => nil,
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Value/)
  end
end
