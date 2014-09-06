require "rails_helper"

RSpec.describe MerkmalklassenController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/merkmalklassen").to route_to("merkmalklassen#index")
    end

    it "routes to #new" do
      expect(:get => "/merkmalklassen/new").to route_to("merkmalklassen#new")
    end

    it "routes to #show" do
      expect(:get => "/merkmalklassen/1").to route_to("merkmalklassen#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/merkmalklassen/1/edit").to route_to("merkmalklassen#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/merkmalklassen").to route_to("merkmalklassen#create")
    end

    it "routes to #update" do
      expect(:put => "/merkmalklassen/1").to route_to("merkmalklassen#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/merkmalklassen/1").to route_to("merkmalklassen#destroy", :id => "1")
    end

  end
end
