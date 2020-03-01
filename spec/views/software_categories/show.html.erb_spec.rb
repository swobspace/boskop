require 'rails_helper'

RSpec.describe "software_categories/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "software_categories" }
    allow(controller).to receive(:action_name) { "show" }

    @software_category = assign(:software_category, SoftwareCategory.create!(
      name: "Name",
      description: "MyDescription",
      main_business_process: "MyProcess"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyDescription/)
    expect(rendered).to match(/MyProcess/)
  end
end
