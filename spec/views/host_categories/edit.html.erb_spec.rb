require 'rails_helper'

RSpec.describe "host_categories/edit", type: :view do
  before(:each) do
   @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "host_categories" }
    allow(controller).to receive(:action_name) { "edit" }

    @host_category = assign(:host_category, FactoryGirl.create(:host_category))
  end

  it "renders the edit host_category form" do
    render

    assert_select "form[action=?][method=?]", host_category_path(@host_category), "post" do

      assert_select "input[name=?]", "host_category[name]"

      assert_select "textarea[name=?]", "host_category[description]"
    end
  end
end
