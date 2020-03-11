require 'rails_helper'

RSpec.describe "software_categories/index", type: :view do
  let(:swgrp) { FactoryBot.create(:software_group, name: "SomeGroup") }
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software_categories" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:software_categories, [
      SoftwareCategory.create!(
        name: "Name1",
        description: "MyDescription",
        main_business_process: "MyProcess",
        software_group_id: swgrp.id
      ),
      SoftwareCategory.create!(
        name: "Name2",
        description: "MyDescription",
        main_business_process: "MyProcess",
        software_group_id: swgrp.id
      )
    ])
  end

  it "renders a list of software_categories" do
    render
    assert_select "tr>td", text: "Name1".to_s, count: 1
    assert_select "tr>td", text: "Name2".to_s, count: 1
    assert_select "tr>td", text: "MyDescription".to_s, count: 2
    assert_select "tr>td", text: "MyProcess".to_s, count: 2
    assert_select "tr>td", text: "SomeGroup".to_s, count: 2
  end
end
