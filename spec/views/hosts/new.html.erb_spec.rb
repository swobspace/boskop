require 'rails_helper'

RSpec.describe "hosts/new", type: :view do
  before(:each) do
    assign(:host, Host.new(
      :name => "MyString",
      :description => "MyText",
      :ip => "",
      :cpe => "MyString",
      :lanmanager => "MyString",
      :operating_system => nil,
      :mac => "MyString",
      :host_category => nil,
      :location => nil
    ))
  end

  it "renders new host form" do
    render

    assert_select "form[action=?][method=?]", hosts_path, "post" do

      assert_select "input[name=?]", "host[name]"

      assert_select "textarea[name=?]", "host[description]"

      assert_select "input[name=?]", "host[ip]"

      assert_select "input[name=?]", "host[cpe]"

      assert_select "input[name=?]", "host[lanmanager]"

      assert_select "input[name=?]", "host[operating_system_id]"

      assert_select "input[name=?]", "host[mac]"

      assert_select "input[name=?]", "host[host_category_id]"

      assert_select "input[name=?]", "host[location_id]"
    end
  end
end
