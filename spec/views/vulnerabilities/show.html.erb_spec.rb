require 'rails_helper'

RSpec.describe "vulnerabilities/show", type: :view do
  before(:each) do
    @vulnerability = assign(:vulnerability, Vulnerability.create!(
      :host => nil,
      :vulnerability_detail => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
