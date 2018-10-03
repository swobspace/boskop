require 'rails_helper'

RSpec.describe "contacts/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "contacts" }
    allow(controller).to receive(:action_name) { "edit" }

    @contact = assign(:contact, FactoryBot.create(:contact))
  end

  it "renders the edit contact form" do
    render

    assert_select "form[action=?][method=?]", contact_path(@contact), "post" do

      assert_select "input[name=?]", "contact[sn]"

      assert_select "input[name=?]", "contact[givenname]"

      assert_select "input[name=?]", "contact[displayname]"

      assert_select "input[name=?]", "contact[title]"

      assert_select "input[name=?]", "contact[anrede]"

      assert_select "input[name=?]", "contact[position]"

      assert_select "input[name=?]", "contact[streetaddress]"

      assert_select "input[name=?]", "contact[plz]"

      assert_select "input[name=?]", "contact[ort]"

      assert_select "input[name=?]", "contact[postfach]"

      assert_select "input[name=?]", "contact[postfachplz]"

      assert_select "input[name=?]", "contact[care_of]"

      assert_select "input[name=?]", "contact[telephone]"

      assert_select "input[name=?]", "contact[telefax]"

      assert_select "input[name=?]", "contact[mobile]"

      assert_select "input[name=?]", "contact[mail]"

      assert_select "input[name=?]", "contact[internet]"
    end
  end
end
