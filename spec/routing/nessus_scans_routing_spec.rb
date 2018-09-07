require "rails_helper"

RSpec.describe NessusScansController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/nessus_scans").to route_to("nessus_scans#index")
    end

    it "routes to #new" do
      expect(:get => "/nessus_scans/new").to route_to("nessus_scans#new")
    end

    it "routes to #show" do
      expect(:get => "/nessus_scans/1").to route_to("nessus_scans#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/nessus_scans/1/edit").to route_to("nessus_scans#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/nessus_scans").to route_to("nessus_scans#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/nessus_scans/1").to route_to("nessus_scans#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/nessus_scans/1").to route_to("nessus_scans#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/nessus_scans/1").to route_to("nessus_scans#destroy", :id => "1")
    end
  end
end
