require 'rails_helper'

RSpec.describe "LineStates", type: :request do
  describe "GET /line_states" do
    it "works! (now write some real specs)" do
      get line_states_path
      expect(response).to have_http_status(200)
    end
  end
end
