require "rails_helper"

RSpec.describe SoftwareCategoriesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/software_categories").to route_to("software_categories#index")
    end

    it "routes to #new" do
      expect(get: "/software_categories/new").to route_to("software_categories#new")
    end

    it "routes to #show" do
      expect(get: "/software_categories/1").to route_to("software_categories#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/software_categories/1/edit").to route_to("software_categories#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/software_categories").to route_to("software_categories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/software_categories/1").to route_to("software_categories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/software_categories/1").to route_to("software_categories#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/software_categories/1").to route_to("software_categories#destroy", id: "1")
    end
  end
end
