require 'rails_helper'

RSpec.describe "lines/show", type: :view do
  let(:user) { double }
  let(:location) { FactoryGirl.create(:location, name: 'Nirgendwo') }
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "lines" }
    allow(controller).to receive(:action_name) { "show" }
    allow(user).to receive(:can?).and_return(true)
    allow(controller).to receive(:current_user) { user }


    @line = assign(:line, Line.create!(
      :name => "Name",
      :description => "MyDescription",
      :notes => "additional information",
      :provider_id => "Provider",
      :location_a_id => location.id,
      :location_b_id => nil,
      :access_type_id => 1,
      :bw_upstream => "9.99",
      :bw_downstream => "19.99",
      :bw2_upstream => "1.99",
      :bw2_downstream => "4.99",
      :framework_contract => nil,
      :contract_period => "2",
      :period_of_notice => 3,
      :period_of_notice_unit => "month",
      :renewal_period => 2,
      :renewal_unit => "year",
      :line_state_id => 1
    ))
    expect(@line).to receive(:location_b).at_least(:once).and_return("---")
    expect(@line).to receive(:access_type).and_return("VDSL")
    expect(@line).to receive(:framework_contract).at_least(:once).and_return("myFrameworkContract")
    expect(@line).to receive(:line_state).and_return("active")
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyDescription/)
    expect(rendered).to match(/additional information/)
    expect(rendered).to match(/Provider/)
    expect(rendered).to match(/#{location.lid} \/ Nirgendwo \/  /)
    expect(rendered).to match(/---/)
    expect(rendered).to match(/VDSL/)
    expect(rendered).to match(/10.0/)
    expect(rendered).to match(/20.0/)
    expect(rendered).to match(/2.0/)
    expect(rendered).to match(/5.0/)
    expect(rendered).to match(/myFrameworkContract/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3 month/)
    expect(rendered).to match(/2 year/)
    expect(rendered).to match(/active/)
  end
end
