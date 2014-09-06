require 'rails_helper'

RSpec.describe "merkmalklassen/index", :type => :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "sites" }
    allow(controller).to receive(:action_name) { "index" }

    assign(:merkmalklassen, [
      Merkmalklasse.create!(
        :name => "Name01",
        :description => "MyText",
        :format => "string",
        :visible => ['index'],
        :for_object => 'OrgUnit',
        :possible_values => "MyValues"
      ),
      Merkmalklasse.create!(
        :name => "Name02",
        :description => "MyText",
        :format => "string",
        :visible => ['index'],
        :for_object => 'OrgUnit',
        :possible_values => "MyValues"
      )
    ])
  end

  it "renders a list of merkmalklassen" do
    render
    assert_select "tr>td", :text => "Name01".to_s, :count => 1
    assert_select "tr>td", :text => "Name02".to_s, :count => 1
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "string".to_s, :count => 2
    assert_select "tr>td", :text => "MyValues".to_s, :count => 2
  end
end
