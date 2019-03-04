require "rails_helper"

RSpec.describe MacPrefixesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/mac_prefixes").to route_to("mac_prefixes#index")
    end

    it "routes to #new" do
      expect(:get => "/mac_prefixes/new").to route_to("mac_prefixes#new")
    end

    it "routes to #show" do
      expect(:get => "/mac_prefixes/1").to route_to("mac_prefixes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/mac_prefixes/1/edit").to route_to("mac_prefixes#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/mac_prefixes").to route_to("mac_prefixes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/mac_prefixes/1").to route_to("mac_prefixes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/mac_prefixes/1").to route_to("mac_prefixes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/mac_prefixes/1").to route_to("mac_prefixes#destroy", :id => "1")
    end
  end
end
