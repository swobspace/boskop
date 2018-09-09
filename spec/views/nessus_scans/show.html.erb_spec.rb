require 'rails_helper'

RSpec.describe "nessus_scans/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "nessus_scans" }
    allow(controller).to receive(:action_name) { "show" }

    @nessus_scan = assign(:nessus_scan, FactoryBot.create(:nessus_scan,
      :nessus_id => "Nessus",
      :uuid => "Uuid",
      :name => "Name",
      :status => "Status",
      :import_state => "failed",
      :import_mode => "auto"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nessus/)
    expect(rendered).to match(/Uuid/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/failed/)
    expect(rendered).to match(/auto/)
  end
end
