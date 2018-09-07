require 'rails_helper'

RSpec.describe "nessus_scans/show", type: :view do
  before(:each) do
    @nessus_scan = assign(:nessus_scan, NessusScan.create!(
      :nessus_id => "Nessus",
      :uuid => "Uuid",
      :name => "Name",
      :status => "Status",
      :import_state => "Import State"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nessus/)
    expect(rendered).to match(/Uuid/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Import State/)
  end
end
