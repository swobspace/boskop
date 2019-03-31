require 'rails_helper'

RSpec.describe "network_interfaces/edit", type: :view do
  before(:each) do
    @network_interface = assign(:network_interface, NetworkInterface.create!(
      :host => nil,
      :description => "MyString",
      :ip => "",
      :mac => "MyString",
      :oui_vendor => "MyString"
    ))
  end

  it "renders the edit network_interface form" do
    render

    assert_select "form[action=?][method=?]", network_interface_path(@network_interface), "post" do

      assert_select "input[name=?]", "network_interface[host_id]"

      assert_select "input[name=?]", "network_interface[description]"

      assert_select "input[name=?]", "network_interface[ip]"

      assert_select "input[name=?]", "network_interface[mac]"

      assert_select "input[name=?]", "network_interface[oui_vendor]"
    end
  end
end
