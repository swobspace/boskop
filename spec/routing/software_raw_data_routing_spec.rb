require "rails_helper"

RSpec.describe SoftwareRawDataController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/software_raw_data").to route_to("software_raw_data#index")
    end

    it "routes to #new" do
      expect(get: "/software_raw_data/new").to route_to("software_raw_data#new")
    end

    it "routes to #show" do
      expect(get: "/software_raw_data/1").to route_to("software_raw_data#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/software_raw_data/1/edit").to route_to("software_raw_data#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/software_raw_data").to route_to("software_raw_data#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/software_raw_data/1").to route_to("software_raw_data#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/software_raw_data/1").to route_to("software_raw_data#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/software_raw_data/1").to route_to("software_raw_data#destroy", id: "1")
    end

    it "routes to #new_import" do
      expect(:get => "/software_raw_data/new_import").to route_to("software_raw_data#new_import")
    end

    it "routes to #add_software" do
      expect(:get => "/software_raw_data/17/add_software").to route_to("software_raw_data#add_software", id: "17")
    end


    it "routes to #import" do
      expect(:post => "/software_raw_data/import").to route_to("software_raw_data#import")
    end

    it "routes to #search" do
      expect(:get => "software_raw_data/search").to route_to("software_raw_data#search")
    end

    it "routes to #search" do
      expect(:post => "software_raw_data/search").to route_to("software_raw_data#search")
    end

    it "routes to #search_form" do
      expect(:get => "software_raw_data/search_form").to route_to("software_raw_data#search_form")
    end



  end
end
