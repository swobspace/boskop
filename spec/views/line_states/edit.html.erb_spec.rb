require 'rails_helper'

RSpec.describe "line_states/edit", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "line_states" }
    allow(controller).to receive(:action_name) { "edit" }

    @line_state = assign(:line_state, LineState.create!(
      :name => "MyString",
      :description => "MyText",
      :active => false
    ))
  end

  it "renders the edit line_state form" do
    render

    assert_select "form[action=?][method=?]", line_state_path(@line_state), "post" do

      assert_select "input#line_state_name[name=?]", "line_state[name]"

      assert_select "textarea#line_state_description[name=?]", "line_state[description]"

      assert_select "select#line_state_active[name=?]", "line_state[active]"
    end
  end
end
