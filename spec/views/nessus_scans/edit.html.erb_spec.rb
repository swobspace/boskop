require 'rails_helper'

RSpec.describe "nessus_scans/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "nessus_scans" }
    allow(controller).to receive(:action_name) { "edit" }

    @nessus_scan = assign(:nessus_scan, FactoryBot.create(:nessus_scan))
  end

  it "renders the edit nessus_scan form" do
    render

    assert_select "form[action=?][method=?]", nessus_scan_path(@nessus_scan), "post" do
      assert_select "input[name=?]", "nessus_scan[nessus_id]"
      assert_select "input[name=?]", "nessus_scan[uuid]"
      assert_select "input[name=?]", "nessus_scan[name]"
      assert_select "input[name=?]", "nessus_scan[status]"
      assert_select "select[name=?]", "nessus_scan[import_state]"
      assert_select "select[name=?]", "nessus_scan[import_mode]"
    end
  end
end
