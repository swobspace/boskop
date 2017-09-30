require 'rails_helper'

RSpec.describe "vulnerabilities/new", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "vulnerability" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:vulnerability, FactoryGirl.build(:vulnerability))
  end

  it "renders new vulnerability form" do
    render

    assert_select "form[action=?][method=?]", vulnerabilities_path, "post" do

      assert_select "select[name=?]", "vulnerability[host_id]"
      assert_select "select[name=?]", "vulnerability[vulnerability_detail_id]"
      assert_select "input[name=?]", "vulnerability[lastseen]"
    end
  end
end
