require "rails_helper"

RSpec.describe VulnerabilitiesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/vulnerabilities").to route_to("vulnerabilities#index")
    end

    it "routes to #search" do
      expect(:get => "/vulnerabilities/search").to route_to("vulnerabilities#search")
    end

    it "routes to #search" do
      expect(:post => "/vulnerabilities/search").to route_to("vulnerabilities#search")
    end

    it "routes to #search_form" do
      expect(:get => "/vulnerabilities/search_form").to route_to("vulnerabilities#search_form")
    end


    it "routes to #new" do
      expect(:get => "/vulnerabilities/new").to route_to("vulnerabilities#new")
    end

    it "routes to #new_import" do
      expect(:get => "/vulnerabilities/new_import").to route_to("vulnerabilities#new_import")
    end

    it "routes to #import" do
      expect(:post => "/vulnerabilities/import").to route_to("vulnerabilities#import")
    end


    it "routes to #show" do
      expect(:get => "/vulnerabilities/1").to route_to("vulnerabilities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/vulnerabilities/1/edit").to route_to("vulnerabilities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/vulnerabilities").to route_to("vulnerabilities#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/vulnerabilities/1").to route_to("vulnerabilities#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/vulnerabilities/1").to route_to("vulnerabilities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/vulnerabilities/1").to route_to("vulnerabilities#destroy", :id => "1")
    end

  end
end
