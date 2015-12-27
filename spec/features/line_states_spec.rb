require 'rails_helper'

RSpec.describe "LineStates", type: :feature do
  describe "GET /line_states" do
    it "visits line_states#index" do
      login_user
      visit line_states_path
      expect(current_path).to eq(line_states_path)
    end
  end
end
