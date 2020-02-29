require "rails_helper"

RSpec.describe SoftwaresController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/softwares").to route_to("softwares#index")
    end

    it "routes to #new" do
      expect(get: "/softwares/new").to route_to("softwares#new")
    end

    it "routes to #show" do
      expect(get: "/softwares/1").to route_to("softwares#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/softwares/1/edit").to route_to("softwares#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/softwares").to route_to("softwares#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/softwares/1").to route_to("softwares#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/softwares/1").to route_to("softwares#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/softwares/1").to route_to("softwares#destroy", id: "1")
    end
  end
end
