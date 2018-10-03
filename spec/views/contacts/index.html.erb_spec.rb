require 'rails_helper'

RSpec.describe "contacts/index", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "contacts" }
    allow(controller).to receive(:action_name) { "new" }

    assign(:contacts, [
      Contact.create!(
        :sn => "Sn",
        :givenname => "Givenname",
        :displayname => "Displayname",
        :title => "Title",
        :anrede => "Anrede",
        :position => "Position",
        :streetaddress => "Streetaddress",
        :plz => "Plz",
        :ort => "Ort",
        :postfach => "Postfach",
        :postfachplz => "Postfachplz",
        :care_of => "Care Of",
        :telephone => "Telephone",
        :telefax => "Telefax",
        :mobile => "Mobile",
        :mail => "mail1@example.net",
        :internet => "Internet"
      ),
      Contact.create!(
        :sn => "Sn",
        :givenname => "Givenname",
        :displayname => "Displayname",
        :title => "Title",
        :anrede => "Anrede",
        :position => "Position",
        :streetaddress => "Streetaddress",
        :plz => "Plz",
        :ort => "Ort",
        :postfach => "Postfach",
        :postfachplz => "Postfachplz",
        :care_of => "Care Of",
        :telephone => "Telephone",
        :telefax => "Telefax",
        :mobile => "Mobile",
        :mail => "mail2@example.net",
        :internet => "Internet"
      )
    ])
  end

  it "renders a list of contacts" do
    render
    assert_select "tr>td", :text => "Sn".to_s, :count => 2
    assert_select "tr>td", :text => "Givenname".to_s, :count => 2
    assert_select "tr>td", :text => "Displayname".to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Anrede".to_s, :count => 2
    assert_select "tr>td", :text => "Position".to_s, :count => 2
    assert_select "tr>td", :text => "Streetaddress".to_s, :count => 2
    assert_select "tr>td", :text => "Plz".to_s, :count => 2
    assert_select "tr>td", :text => "Ort".to_s, :count => 2
    assert_select "tr>td", :text => "Postfach".to_s, :count => 2
    assert_select "tr>td", :text => "Postfachplz".to_s, :count => 2
    assert_select "tr>td", :text => "Care Of".to_s, :count => 2
    assert_select "tr>td", :text => "Telephone".to_s, :count => 2
    assert_select "tr>td", :text => "Telefax".to_s, :count => 2
    assert_select "tr>td", :text => "Mobile".to_s, :count => 2
    assert_select "tr>td", :text => "mail1@example.net".to_s, :count => 1
    assert_select "tr>td", :text => "mail1@example.net".to_s, :count => 1
    assert_select "tr>td", :text => "Internet".to_s, :count => 2
  end
end
