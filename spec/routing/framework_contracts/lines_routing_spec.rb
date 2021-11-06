require "rails_helper"

RSpec.describe LinesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/framework_contracts/77/lines").to route_to("framework_contracts/lines#index", framework_contract_id: "77")
    end

    it "routes to #new" do
      expect(:get => "/framework_contracts/77/lines/new").to route_to("framework_contracts/lines#new", framework_contract_id: "77")
    end

    it "routes to #show" do
      expect(:get => "/framework_contracts/77/lines/1").to route_to("framework_contracts/lines#show", :id => "1", framework_contract_id: "77")
    end

    it "routes to #edit" do
      expect(:get => "/framework_contracts/77/lines/1/edit").to route_to("framework_contracts/lines#edit", :id => "1", framework_contract_id: "77")
    end

    it "routes to #create" do
      expect(:post => "/framework_contracts/77/lines").to route_to("framework_contracts/lines#create", framework_contract_id: "77")
    end

    it "routes to #update via PUT" do
      expect(:put => "/framework_contracts/77/lines/1").to route_to("framework_contracts/lines#update", :id => "1", framework_contract_id: "77")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/framework_contracts/77/lines/1").to route_to("framework_contracts/lines#update", :id => "1", framework_contract_id: "77")
    end

    it "routes to #destroy" do
      expect(:delete => "/framework_contracts/77/lines/1").to route_to("framework_contracts/lines#destroy", :id => "1", framework_contract_id: "77")
    end

  end
end
