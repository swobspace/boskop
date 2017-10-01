require 'rails_helper'

RSpec.describe "vulnerabilities/new_import", type: :view do
  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    allow(controller).to receive(:current_ability) { @ability }
    allow(controller).to receive(:controller_name) { "vulnerabilities" }
    allow(controller).to receive(:action_name) { "new_import" }
  end

  it "renders new_import form" do
    render

    assert_select "form[action=?][method=?]", import_vulnerabilities_path, "post" do
      assert_select "input[name=?]", "file"
      assert_select "select[name=?]", "type"
    end
  end
end
