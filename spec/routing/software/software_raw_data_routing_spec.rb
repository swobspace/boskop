require "rails_helper"

RSpec.describe Software::SoftwareRawDataController, type: :routing do
  describe "routing" do
    it "routes to #remove via PATCH" do
      expect(patch: "/software/997/software_raw_data/1/remove").to route_to(controller: 'software/software_raw_data', action: 'remove', software_id: '997', id: '1')
    end
  end
end
