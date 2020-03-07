require 'rails_helper'

RSpec.describe "software/index", type: :view do
  let(:swcat) { FactoryBot.create(:software_category) }
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:software, [
      Software.create!(
        name: "Name1",
        pattern: { 'name' => '/Hans/', 'vendor' => '/Fritz/' },
        vendor: "Vendor",
        description: "MyText",
        minimum_allowed_version: "Minimum Allowed Version",
        maximum_allowed_version: "Maximum Allowed Version",
        green: 2.years.before(Date.today),
        yellow: 2.years.after(Date.today),
        red: 10.years.after(Date.today),
        software_category_id: swcat.id
      ),
      Software.create!(
        name: "Name2",
        pattern: { 'name' => '/Hans/', 'vendor' => '/Fritz/' },
        vendor: "Vendor",
        description: "MyText",
        minimum_allowed_version: "Minimum Allowed Version",
        maximum_allowed_version: "Maximum Allowed Version",
        green: 2.years.before(Date.today),
        yellow: 2.years.after(Date.today),
        red: 10.years.after(Date.today),
        software_category_id: swcat.id
      )
    ])
  end

  it "renders a list of software" do
    render
    assert_select "tr>td", text: "Name1".to_s, count: 1
    assert_select "tr>td", text: "Name2".to_s, count: 1
    assert_select "tr>td", text: { 'name' => '/Hans/', 'vendor' => '/Fritz/' }.to_s, count: 2
    assert_select "tr>td", text: "Vendor".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Minimum Allowed Version".to_s, count: 2
    assert_select "tr>td", text: "Maximum Allowed Version".to_s, count: 2
    assert_select "tr>td", text: swcat.to_s, count: 2
    assert_select "tr>td", text: 2.years.before(Date.today).to_s, count: 2
    assert_select "tr>td", text: 2.years.after(Date.today).to_s, count: 2
    assert_select "tr>td", text: 10.years.after(Date.today).to_s, count: 2
  end
end
