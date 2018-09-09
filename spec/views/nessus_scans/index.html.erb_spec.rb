require 'rails_helper'

RSpec.describe "nessus_scans/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "nessus_scans" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:nessus_scans, [
      FactoryBot.create(:nessus_scan,
        :nessus_id => "Nessus1",
        :uuid => "Uuid1",
        :name => "Name",
        :status => "Status",
        :import_state => "failed",
        :import_mode => "auto"
      ),
      FactoryBot.create(:nessus_scan,
        :nessus_id => "Nessus2",
        :uuid => "Uuid2",
        :name => "Name",
        :status => "Status",
        :import_state => "failed",
        :import_mode => "auto"
      )
    ])
  end

  it "renders a list of nessus_scans" do
    render
    assert_select "tr>td", :text => "Nessus1".to_s, :count => 1
    assert_select "tr>td", :text => "Nessus2".to_s, :count => 1
    assert_select "tr>td", :text => "Uuid1".to_s, :count => 1
    assert_select "tr>td", :text => "Uuid2".to_s, :count => 1
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "failed".to_s, :count => 2
    assert_select "tr>td", :text => "auto".to_s, :count => 2
  end
end
