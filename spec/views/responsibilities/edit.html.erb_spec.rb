require 'rails_helper'

RSpec.describe "responsibilities/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "responsibilities" }
    allow(controller).to receive(:action_name) { "edit" }

    @responsibility = assign(:responsibility, FactoryBot.create(:responsibility))
  end

  it "renders the edit responsibility form" do
    render

    assert_select "form[action=?][method=?]", responsibility_path(@responsibility), "post" do
      assert_select "input[name=?]", "responsibility[responsibility_for_type]"
      assert_select "select[name=?]", "responsibility[responsibility_for_id]"
      assert_select "select[name=?]", "responsibility[contact_id]"
      assert_select "select[name=?]", "responsibility[role]"
      assert_select "input[name=?]", "responsibility[title]"
      assert_select "input[name=?]", "responsibility[position]"
    end
  end
end
