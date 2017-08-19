require 'rails_helper'

RSpec.describe "hosts/show", type: :view do
  before(:each) do
    @host = assign(:host, Host.create!(
      :name => "Name",
      :description => "MyText",
      :ip => "",
      :cpe => "Cpe",
      :lanmanager => "Lanmanager",
      :operating_system => nil,
      :mac => "Mac",
      :host_category => nil,
      :location => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Cpe/)
    expect(rendered).to match(/Lanmanager/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Mac/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
