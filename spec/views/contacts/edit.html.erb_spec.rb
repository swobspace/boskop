require 'rails_helper'

RSpec.describe "contacts/edit", type: :view do
  before(:each) do
    @contact = assign(:contact, Contact.create!(
      :sn => "MyString",
      :givenname => "MyString",
      :displayname => "MyString",
      :title => "MyString",
      :anrede => "MyString",
      :position => "MyString",
      :streetaddress => "MyString",
      :plz => "MyString",
      :ort => "MyString",
      :postfach => "MyString",
      :postfachplz => "MyString",
      :care_of => "MyString",
      :telephone => "MyString",
      :telefax => "MyString",
      :mobile => "MyString",
      :mail => "MyString",
      :internet => "MyString"
    ))
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
