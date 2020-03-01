require 'rails_helper'

RSpec.describe "software/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software" }
    allow(controller).to receive(:action_name) { "show" }

    @software = assign(:software, Software.create!(
      name: "Name",
      pattern: "MyText",
      vendor: "Vendor",
      description: "MyText",
      minimum_allowed_version: "Minimum Allowed Version",
      maximum_allowed_version: "Maximum Allowed Version",
      green: 2.years.before(Date.today),
      yellow: 2.years.after(Date.today),
      red: 10.years.after(Date.today),
      software_category: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Vendor/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Minimum Allowed Version/)
    expect(rendered).to match(/Maximum Allowed Version/)
    expect(rendered).to match(/#{2.years.before(Date.today).to_s}/)
    expect(rendered).to match(/#{2.years.after(Date.today).to_s}/)
    expect(rendered).to match(/#{10.years.after(Date.today).to_s}/)
  end
end
