require 'rails_helper'

RSpec.describe "host_categories/new", type: :view do
  before(:each) do
   @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "host_categories" }
    allow(controller).to receive(:action_name) { "new" }

    @host_category = assign(:host_category, FactoryBot.build(:host_category))
  end

  it "renders new host_category form" do
    render

    assert_select "form[action=?][method=?]", host_categories_path, "post" do

      assert_select "input[name=?]", "host_category[name]"
      assert_select "input[name=?]", "host_category[tag]"
      assert_select "textarea[name=?]", "host_category[description]"
    end
  end
end
