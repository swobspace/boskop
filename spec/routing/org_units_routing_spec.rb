require "rails_helper"

RSpec.describe OrgUnitsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/org_units").to route_to("org_units#index")
    end

    it "routes to #new" do
      expect(:get => "/org_units/new").to route_to("org_units#new")
    end

    it "routes to #show" do
      expect(:get => "/org_units/1").to route_to("org_units#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/org_units/1/edit").to route_to("org_units#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/org_units").to route_to("org_units#create")
    end

    it "routes to #update" do
      expect(:put => "/org_units/1").to route_to("org_units#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/org_units/1").to route_to("org_units#destroy", :id => "1")
    end

  end
end
