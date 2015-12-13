require 'rails_helper'

RSpec.describe "lines/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "lines" }
    allow(controller).to receive(:action_name) { "edit" }

    @line = assign(:line, Line.create!(
      :name => "Name",
      :description => "MyText",
      :provider_id => "Provider",
      :location_a_id => 1,
      :location_b_id => 2,
      :access_type => nil,
      :bw_upstream => "9.99",
      :bw_downstream => "9.99",
      :framework_contract => nil,
      :contract_period => 3,
      :period_of_notice => 4,
      :period_of_notice_unit => "Period Of Notice Unit",
      :renewal_period => 5,
      :renewal_unit => "Renewal Unit",
      :line_state => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Provider/)
    expect(rendered).to match(/1/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/Period Of Notice Unit/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/Renewal Unit/)
    expect(rendered).to match(//)
  end
end
