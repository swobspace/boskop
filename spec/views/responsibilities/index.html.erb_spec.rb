require 'rails_helper'

RSpec.describe "responsibilities/index", type: :view do
  let(:location) { FactoryBot.create(:location, name: 'ACME Ltd.') }
  let(:contact) { FactoryBot.create(:contact, sn: "Mustermann", givenname: "Hans") }
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "responsibilities" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:responsibilities, [
      Responsibility.create!(
        :responsibility_for => location,
        :contact => contact,
        :role => "Vulnerabilities",
        :title => "Title"
      ),
      Responsibility.create!(
        :responsibility_for => location,
        :contact => contact,
        :role => "Vulnerabilities",
        :title => "Title"
      )
    ])
  end

  it "renders a list of responsibilities" do
    render
    assert_select "tr>td", :text => "ACME Ltd.".to_s, :count => 2
    assert_select "tr>td", :text => "Mustermann, Hans".to_s, :count => 2
    assert_select "tr>td", :text => "Vulnerabilities".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "1".to_s, :count => 1
    assert_select "tr>td", :text => "2".to_s, :count => 1
  end
end
