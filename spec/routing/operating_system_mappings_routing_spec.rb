require "rails_helper"

RSpec.describe OperatingSystemMappingsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/operating_system_mappings").to route_to("operating_system_mappings#index")
    end

    it "routes to #new" do
      expect(:get => "/operating_system_mappings/new").to route_to("operating_system_mappings#new")
    end

    it "routes to #show" do
      expect(:get => "/operating_system_mappings/1").to route_to("operating_system_mappings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/operating_system_mappings/1/edit").to route_to("operating_system_mappings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/operating_system_mappings").to route_to("operating_system_mappings#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/operating_system_mappings/1").to route_to("operating_system_mappings#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/operating_system_mappings/1").to route_to("operating_system_mappings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/operating_system_mappings/1").to route_to("operating_system_mappings#destroy", :id => "1")
    end

  end
end
