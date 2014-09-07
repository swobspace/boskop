require "rails_helper"

RSpec.describe MerkmaleController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/merkmale").to route_to("merkmale#index")
    end

    it "routes to #new" do
      expect(:get => "/merkmale/new").to route_to("merkmale#new")
    end

    it "routes to #show" do
      expect(:get => "/merkmale/1").to route_to("merkmale#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/merkmale/1/edit").to route_to("merkmale#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/merkmale").to route_to("merkmale#create")
    end

    it "routes to #update" do
      expect(:put => "/merkmale/1").to route_to("merkmale#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/merkmale/1").to route_to("merkmale#destroy", :id => "1")
    end

  end
end
