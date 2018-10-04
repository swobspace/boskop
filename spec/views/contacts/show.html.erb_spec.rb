require 'rails_helper'

RSpec.describe "contacts/show", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "contacts" }
    allow(controller).to receive(:action_name) { "new" }

    @contact = assign(:contact, Contact.create!(
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
      :mail => "Mail",
      :internet => "Internet"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Sn/)
    expect(rendered).to match(/Givenname/)
    expect(rendered).to match(/Displayname/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Anrede/)
    expect(rendered).to match(/Position/)
    expect(rendered).to match(/Streetaddress/)
    expect(rendered).to match(/Plz/)
    expect(rendered).to match(/Ort/)
    expect(rendered).to match(/Postfach/)
    expect(rendered).to match(/Postfachplz/)
    expect(rendered).to match(/Care Of/)
    expect(rendered).to match(/Telephone/)
    expect(rendered).to match(/Telefax/)
    expect(rendered).to match(/Mobile/)
    expect(rendered).to match(/Mail/)
    expect(rendered).to match(/Internet/)
  end
end
