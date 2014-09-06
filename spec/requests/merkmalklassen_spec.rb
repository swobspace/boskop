require 'rails_helper'

RSpec.describe "Merkmalklassen", :type => :request do
  describe "GET /merkmalklassen" do
    it "works! (now write some real specs)" do
      get merkmalklassen_path
      expect(response).to have_http_status(200)
    end
  end
end
