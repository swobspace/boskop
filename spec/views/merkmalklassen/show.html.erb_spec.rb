require 'rails_helper'

RSpec.describe "merkmalklassen/show", :type => :view do
  before(:each) do
    @merkmalklasse = assign(:merkmalklasse, Merkmalklasse.create!(
      :name => "Name",
      :description => "MyText",
      :format => "Format",
      :possible_values => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Format/)
    expect(rendered).to match(/MyText/)
  end
end
