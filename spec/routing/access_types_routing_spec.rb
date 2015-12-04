require "rails_helper"

RSpec.describe AccessTypesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/access_types").to route_to("access_types#index")
    end

    it "routes to #new" do
      expect(:get => "/access_types/new").to route_to("access_types#new")
    end

    it "routes to #show" do
      expect(:get => "/access_types/1").to route_to("access_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/access_types/1/edit").to route_to("access_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/access_types").to route_to("access_types#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/access_types/1").to route_to("access_types#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/access_types/1").to route_to("access_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/access_types/1").to route_to("access_types#destroy", :id => "1")
    end

  end
end
