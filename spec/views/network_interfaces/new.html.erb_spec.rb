require 'rails_helper'

RSpec.describe "network_interfaces/new", type: :view do
  before(:each) do
    assign(:network_interface, NetworkInterface.new(
      :host => nil,
      :description => "MyString",
      :ip => "",
      :mac => "MyString",
      :oui_vendor => "MyString"
    ))
  end

  it "renders new network_interface form" do
    render

    assert_select "form[action=?][method=?]", network_interfaces_path, "post" do

      assert_select "input[name=?]", "network_interface[host_id]"

      assert_select "input[name=?]", "network_interface[description]"

      assert_select "input[name=?]", "network_interface[ip]"

      assert_select "input[name=?]", "network_interface[mac]"

      assert_select "input[name=?]", "network_interface[oui_vendor]"
    end
  end
end
