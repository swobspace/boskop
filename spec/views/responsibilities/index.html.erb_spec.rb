require 'rails_helper'

RSpec.describe "responsibilities/index", type: :view do
  let(:address) { FactoryBot.create(:address, plz: '12345', ort: 'Nirgendwo') }
  let(:location) { FactoryBot.create(:location, 
    name: 'ACME Ltd.', 
    lid: 'ACE',
    addresses: [address]
  )}
  let(:contact) { FactoryBot.create(:contact, 
    sn: "Mustermann", 
    givenname: "Hans",
    mail: 'hm@muster.de'
  )}
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
    puts rendered
    assert_select "tr>td", :text => "ACE / ACME Ltd. / 12345 Nirgendwo".to_s, :count => 2
    assert_select "tr>td", :text => "Mustermann, Hans <hm@muster.de>".to_s, :count => 2
    assert_select "tr>td", :text => "Vulnerabilities".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "1".to_s, :count => 1
    assert_select "tr>td", :text => "2".to_s, :count => 1

  end
end
