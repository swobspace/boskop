require 'rails_helper'

RSpec.describe "merkmalklassen/show", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "sites" }
    allow(controller).to receive(:action_name) { "new" }

    @merkmalklasse = assign(:merkmalklasse, Merkmalklasse.create!(
      :name => "Name",
      :description => "MyText",
      :format => "string",
      :visible => ['index'],
      :for_object => 'OrgUnit',
      :possible_values => ["MyValue"]
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/string/)
    expect(rendered).to match(/index/)
    expect(rendered).to match(/OrgUnit/)
    expect(rendered).to match(/MyValue/)
  end
end
