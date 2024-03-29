require 'rails_helper'

RSpec.describe "lines/index", type: :view do
  let(:loc1) { FactoryBot.create(:location, lid: "LID1", name: 'Nirgendwo1') }
  let(:loc2) { FactoryBot.create(:location, lid: "LID2", name: 'Nirgendwo2') }

  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "lines" }
    allow(controller).to receive(:action_name) { "index" }

    access_type = FactoryBot.create(:access_type)
    line_state  = FactoryBot.create(:line_state)

    assign(:lines, [
      Line.create!(
        :name => "Name1",
        :description => "MyText",
        :notes => "additional information",
        :provider_id => "Provider",
        :location_a_id => loc1.id,
        :location_b_id => loc2.id,
        :bw_upstream => "9.89",
        :bw_downstream => "19.99",
        :bw2_upstream => "1.54",
        :bw2_downstream => "4.99",
        :framework_contract => nil,
        :contract_period => 7,
        :period_of_notice => 2,
        :period_of_notice_unit => "year",
        :renewal_period => 3,
        :renewal_unit => "month",
        :access_type_id => access_type.id,
        :line_state_id => line_state.id
      ),
      Line.create!(
        :name => "Name2",
        :description => "MyText",
        :notes => "additional information",
        :provider_id => "Provider",
        :location_a_id => loc1.id,
        :location_b_id => loc2.id,
        :bw_upstream => "9.89",
        :bw_downstream => "19.99",
        :bw2_upstream => "1.54",
        :bw2_downstream => "4.99",
        :framework_contract => nil,
        :contract_period => 7,
        :period_of_notice => 2,
        :period_of_notice_unit => "year",
        :renewal_period => 3,
        :renewal_unit => "month",
        :access_type_id => access_type.id,
        :line_state_id => line_state.id
      )
    ])
    allow_any_instance_of(Line).to receive(:access_type).and_return("VDSL")
    allow_any_instance_of(Line).to receive(:framework_contract).and_return("myFrameworkContract")
    allow_any_instance_of(Line).to receive_message_chain(:line_state, :active).and_return(true)

  end

  it "renders a list of lines" do
    render
    assert_select "tr>td", :text => "Name1".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "additional information".to_s, :count => 2
    assert_select "tr>td", :text => "Provider".to_s, :count => 2
    expect(rendered).to include("LID1 / Nirgendwo1 /  ")
    expect(rendered).to include("LID2 / Nirgendwo2 /  ")
    assert_select "tr>td", :text => "20.0/9.9".to_s, :count => 2
    assert_select "tr>td", :text => "5.0/1.5".to_s, :count => 2
    assert_select "tr>td", :text => "myFrameworkContract".to_s, :count => 2
    expect(rendered).to include("7 <br />")
    expect(rendered).to include("2 year <br />")
    expect(rendered).to include("3 month")
    assert_select "tr>td", :text => "true".to_s, :count => 2
  end
end
