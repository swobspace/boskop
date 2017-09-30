require 'rails_helper'

RSpec.describe "vulnerabilities/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "vulnerability" }
    allow(controller).to receive(:action_name) { "index" }

    host = FactoryGirl.create(:host, ip: '192.81.51.117', name: 'vxserver')
    assign(:vulnerabilities, [
      Vulnerability.create!(
        :host => host,
        :lastseen => 1.day.before(Date.today),
        :vulnerability_detail => FactoryGirl.create(:vulnerability_detail,
                                   name: "End-of-Life")
      ),
      Vulnerability.create!(
        :host => host,
        :lastseen => 1.day.before(Date.today),
        :vulnerability_detail => FactoryGirl.create(:vulnerability_detail,
                                   name: "Hackable by Kids")
      )
    ])
  end

  it "renders a list of vulnerabilities" do
    render
    assert_select "tr>td", :text => "192.81.51.117 (vxserver)".to_s, :count => 2
    assert_select "tr>td", :text => "End-of-Life".to_s, :count => 1
    assert_select "tr>td", :text => "Hackable by Kids".to_s, :count => 1
    assert_select "tr>td", :text => 1.day.before(Date.today).to_s, :count => 2
  end
end
