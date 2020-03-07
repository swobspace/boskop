require 'rails_helper'

RSpec.describe "software_raw_data/show", type: :view do
  let(:sw) { FactoryBot.create(:software, name: "VeryCommon") }
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software_raw_data" }
    allow(controller).to receive(:action_name) { "show" }

    @software_raw_datum = assign(:software_raw_datum, SoftwareRawDatum.create!(
      software_id: sw.id,
      name: "Name",
      version: "Version",
      vendor: "Vendor",
      count: 2,
      operating_system: "Operating System",
      lastseen: Date.today,
      source: "Source"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/VeryCommon/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Version/)
    expect(rendered).to match(/Vendor/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Operating System/)
    expect(rendered).to match(/#{Date.today.to_s}/)
    expect(rendered).to match(/Source/)
  end
end
