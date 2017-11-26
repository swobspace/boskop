require 'rails_helper'

RSpec.describe "merkmale/show", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "merkmale" }
    allow(controller).to receive(:action_name) { "show" }

    @merkmalklasse = FactoryBot.create(:merkmalklasse)
    @location      = FactoryBot.create(:location)
    @merkmal = assign(:merkmal, Merkmal.create!(
      :merkmalfor => @location,
      :merkmalklasse => @merkmalklasse,
      :value => "Value"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@location}/)
    expect(rendered).to match(/#{@merkmalklasse}/)
    expect(rendered).to match(/Value/)
  end
end
