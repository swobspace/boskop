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
        :tag => "name_eins",
        :description => "MyText",
        :format => "dropdown",
        :visible => ['index'],
        :for_object => 'OrgUnit',
        :possible_values => ["MyValue1"]
      ),
      Merkmalklasse.create!(
        :name => "Name02",
        :tag => "name_zwo",
        :description => "MyText",
        :format => "string",
        :visible => ['index'],
        :for_object => 'OrgUnit',
        :possible_values => ["MyValue3"]
      )
    ])
  end

    context "when reendering #index" do
      before(:each) do
        render
      end
      it { assert_select "tr>td", :text => "Name01".to_s, :count => 1 }
      it { assert_select "tr>td", :text => "Name02".to_s, :count => 1 }
      it { assert_select "tr>td", :text => "name_eins".to_s, :count => 1 }
      it { assert_select "tr>td", :text => "name_zwo".to_s, :count => 1 }
      it { assert_select "tr>td", :text => "MyText".to_s, :count => 2 }
      it { assert_select "tr>td", :text => "dropdown".to_s, :count => 1 }
      it { assert_select "tr>td", :text => "string".to_s, :count => 1 }
      # -- don't know how to do this
      it { expect(rendered).to match(/[&quot;index&quot;]/) }
      it { expect(rendered).to match(/[&quot;MyValue1&quot;]/) }
      it { expect(rendered).to match(/[&quot;MyValue3&quot;]/) }
    end
end
