require "rails_helper"

RSpec.describe AdUsersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/ad_users").to route_to("ad_users#index")
      expect(:post => "/ad_users").to route_to("ad_users#index")
    end
  end
end
