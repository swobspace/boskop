require "rails_helper"

RSpec.describe NetworkInterfacesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/network_interfaces").to route_to("network_interfaces#index")
    end

    it "routes to #new" do
      expect(:get => "/network_interfaces/new").to route_to("network_interfaces#new")
    end

    it "routes to #show" do
      expect(:get => "/network_interfaces/1").to route_to("network_interfaces#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/network_interfaces/1/edit").to route_to("network_interfaces#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/network_interfaces").to route_to("network_interfaces#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/network_interfaces/1").to route_to("network_interfaces#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/network_interfaces/1").to route_to("network_interfaces#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/network_interfaces/1").to route_to("network_interfaces#destroy", :id => "1")
    end
  end
end
