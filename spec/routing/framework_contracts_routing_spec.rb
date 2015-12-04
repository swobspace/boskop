require "rails_helper"

RSpec.describe FrameworkContractsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/framework_contracts").to route_to("framework_contracts#index")
    end

    it "routes to #new" do
      expect(:get => "/framework_contracts/new").to route_to("framework_contracts#new")
    end

    it "routes to #show" do
      expect(:get => "/framework_contracts/1").to route_to("framework_contracts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/framework_contracts/1/edit").to route_to("framework_contracts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/framework_contracts").to route_to("framework_contracts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/framework_contracts/1").to route_to("framework_contracts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/framework_contracts/1").to route_to("framework_contracts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/framework_contracts/1").to route_to("framework_contracts#destroy", :id => "1")
    end

  end
end
