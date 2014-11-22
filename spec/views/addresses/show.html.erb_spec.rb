require 'rails_helper'

RSpec.describe "addresses/show", :type => :view do
  before(:each) do
    @address = assign(:address, Address.create!(
      :addressfor => nil,
      :streetaddress => "Streetaddress",
      :plz => "Plz",
      :ort => "Ort",
      :care_of => "Care Of",
      :postfach => "Postfach",
      :postfachplz => "Postfachplz"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Streetaddress/)
    expect(rendered).to match(/Plz/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/Care Of/)
    expect(rendered).to match(/Postfach/)
    expect(rendered).to match(/Postfachplz/)
  end
end
