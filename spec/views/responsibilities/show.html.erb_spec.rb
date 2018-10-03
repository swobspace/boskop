require 'rails_helper'

RSpec.describe "responsibilities/show", type: :view do
  let(:location) { FactoryBot.create(:location, name: 'ACME Ltd.') }
  let(:contact) { FactoryBot.create(:contact, sn: "Mustermann", givenname: "Hans") }

  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "responsibilities" }
    allow(controller).to receive(:action_name) { "show" }

    @responsibility = assign(:responsibility, Responsibility.create!(
      :responsibility_for => location,
      :contact => contact,
      :role => Boskop.responsibility_role.first,
      :title => "Title",
      :position => 0
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/ACME Ltd./)
    expect(rendered).to match(/Mustermann, Hans/)
    expect(rendered).to match(/#{Boskop.responsibility_role.first}/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/1/)
  end
end
