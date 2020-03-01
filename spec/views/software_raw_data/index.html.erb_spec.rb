require 'rails_helper'

RSpec.describe "software_raw_data/index", type: :view do
  let(:sw) { FactoryBot.create(:software, name: "VeryCommon", vendor: "Universe Ltd.") }
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software_raw_data" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:software_raw_data, [
      SoftwareRawDatum.create!(
        software_id: sw.id,
        name: "VCommon1",
        version: "Version",
        vendor: "Vendor",
        count: 2,
        operating_system: "Operating System",
        lastseen: Date.today,
        source: "Source"
      ),
      SoftwareRawDatum.create!(
        software_id: sw.id,
        name: "VCommon2",
        version: "Version",
        vendor: "Vendor",
        count: 2,
        operating_system: "Operating System",
        lastseen: Date.today,
        source: "Source"
      )
    ])
  end

  it "renders a list of software_raw_data" do
    render
    assert_select "tr>td", text: "VeryCommon (Universe Ltd.)".to_s, count: 2
    assert_select "tr>td", text: "VCommon1".to_s, count: 1
    assert_select "tr>td", text: "VCommon2".to_s, count: 1
    assert_select "tr>td", text: "Version".to_s, count: 2
    assert_select "tr>td", text: "Vendor".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: "Operating System".to_s, count: 2
    assert_select "tr>td", text: Date.today.to_s, count: 2
    assert_select "tr>td", text: "Source".to_s, count: 2
  end
end
