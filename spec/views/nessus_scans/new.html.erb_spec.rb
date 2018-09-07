require 'rails_helper'

RSpec.describe "nessus_scans/new", type: :view do
  before(:each) do
    assign(:nessus_scan, NessusScan.new(
      :nessus_id => "MyString",
      :uuid => "MyString",
      :name => "MyString",
      :status => "MyString",
      :import_state => "MyString"
    ))
  end

  it "renders new nessus_scan form" do
    render

    assert_select "form[action=?][method=?]", nessus_scans_path, "post" do

      assert_select "input[name=?]", "nessus_scan[nessus_id]"

      assert_select "input[name=?]", "nessus_scan[uuid]"

      assert_select "input[name=?]", "nessus_scan[name]"

      assert_select "input[name=?]", "nessus_scan[status]"

      assert_select "input[name=?]", "nessus_scan[import_state]"
    end
  end
end
