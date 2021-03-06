require "rails_helper"

RSpec.describe HostsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/hosts").to route_to("hosts#index")
    end

    it "routes to #eol_summary" do
      expect(:get => "/hosts/eol_summary").to route_to("hosts#eol_summary")
    end

    it "routes to #vuln_risk_matrix" do
      expect(:get => "/hosts/vuln_risk_matrix").to route_to("hosts#vuln_risk_matrix")
    end

    it "routes to #search" do
      expect(:get => "/hosts/search").to route_to("hosts#search")
    end

    it "routes to #search" do
      expect(:post => "/hosts/search").to route_to("hosts#search")
    end

    it "routes to #search_form" do
      expect(:get => "/hosts/search_form").to route_to("hosts#search_form")
    end

    it "routes to #new" do
      expect(:get => "/hosts/new").to route_to("hosts#new")
    end

    it "routes to #new_import" do
      expect(:get => "/hosts/new_import").to route_to("hosts#new_import")
    end

    it "routes to #import" do
      expect(:post => "/hosts/import").to route_to("hosts#import")
    end

    it "routes to #show" do
      expect(:get => "/hosts/1").to route_to("hosts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/hosts/1/edit").to route_to("hosts#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/hosts").to route_to("hosts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/hosts/1").to route_to("hosts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/hosts/1").to route_to("hosts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/hosts/1").to route_to("hosts#destroy", :id => "1")
    end

  end
end
