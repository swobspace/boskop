require 'rails_helper'

RSpec.describe "addresses/show", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "addresses" }
    allow(controller).to receive(:action_name) { "edit" }

    @location = FactoryGirl.create(:location)

    @address = assign(:address, Address.create!(
      :addressfor => @location,
      :streetaddress => "Streetaddress",
      :plz => "123456",
      :ort => "Ort",
      :care_of => "Care Of",
      :postfach => "Postfach",
      :postfachplz => "Postfachplz"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@location.to_s}/)
    expect(rendered).to match(/Streetaddress/)
    expect(rendered).to match(/123456/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/Care Of/)
    expect(rendered).to match(/Postfach/)
    expect(rendered).to match(/Postfachplz/)
  end
end
