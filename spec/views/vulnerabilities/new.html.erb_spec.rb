require 'rails_helper'

RSpec.describe "vulnerabilities/new", type: :view do
  before(:each) do
    assign(:vulnerability, Vulnerability.new(
      :host => nil,
      :vulnerability_detail => nil
    ))
  end

  it "renders new vulnerability form" do
    render

    assert_select "form[action=?][method=?]", vulnerabilities_path, "post" do

      assert_select "input[name=?]", "vulnerability[host_id]"

      assert_select "input[name=?]", "vulnerability[vulnerability_detail_id]"
    end
  end
end
