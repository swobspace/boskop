require 'rails_helper'

RSpec.describe "vulnerabilities/index", type: :view do
  before(:each) do
    assign(:vulnerabilities, [
      Vulnerability.create!(
        :host => nil,
        :vulnerability_detail => nil
      ),
      Vulnerability.create!(
        :host => nil,
        :vulnerability_detail => nil
      )
    ])
  end

  it "renders a list of vulnerabilities" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
