require "rails_helper"

RSpec.describe HostCategoriesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/host_categories").to route_to("host_categories#index")
    end

    it "routes to #new" do
      expect(:get => "/host_categories/new").to route_to("host_categories#new")
    end

    it "routes to #show" do
      expect(:get => "/host_categories/1").to route_to("host_categories#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/host_categories/1/edit").to route_to("host_categories#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/host_categories").to route_to("host_categories#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/host_categories/1").to route_to("host_categories#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/host_categories/1").to route_to("host_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/host_categories/1").to route_to("host_categories#destroy", :id => "1")
    end

  end
end
