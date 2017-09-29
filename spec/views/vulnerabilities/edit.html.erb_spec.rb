require 'rails_helper'

RSpec.describe "vulnerabilities/edit", type: :view do
  before(:each) do
    @vulnerability = assign(:vulnerability, Vulnerability.create!(
      :host => nil,
      :vulnerability_detail => nil
    ))
  end

  it "renders the edit vulnerability form" do
    render

    assert_select "form[action=?][method=?]", vulnerability_path(@vulnerability), "post" do

      assert_select "input[name=?]", "vulnerability[host_id]"

      assert_select "input[name=?]", "vulnerability[vulnerability_detail_id]"
    end
  end
end
