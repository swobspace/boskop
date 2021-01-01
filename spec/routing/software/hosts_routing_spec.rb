require "rails_helper"

RSpec.describe Software::HostsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get=> "/software/99/hosts").to route_to(controller: "software/hosts", 
             action: "index", software_id: "99")
      expect(:post=> "/software/99/hosts.json").to route_to(controller: "software/hosts", 
             action: "index", software_id: "99", format: 'json')
    end
  end
end
