require 'rails_helper'

RSpec.describe "nessus_scans/index", type: :view do
  before(:each) do
    assign(:nessus_scans, [
      NessusScan.create!(
        :nessus_id => "Nessus",
        :uuid => "Uuid",
        :name => "Name",
        :status => "Status",
        :import_state => "Import State"
      ),
      NessusScan.create!(
        :nessus_id => "Nessus",
        :uuid => "Uuid",
        :name => "Name",
        :status => "Status",
        :import_state => "Import State"
      )
    ])
  end

  it "renders a list of nessus_scans" do
    render
    assert_select "tr>td", :text => "Nessus".to_s, :count => 2
    assert_select "tr>td", :text => "Uuid".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Import State".to_s, :count => 2
  end
end
