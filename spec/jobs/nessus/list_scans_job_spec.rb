require 'rails_helper'

RSpec.describe Nessus::ListScansJob, type: :job do
  describe "#perform" do
    it "doesn't raise an error" do
      expect {
        Nessus::ListScansJob.perform_now
      }.not_to raise_error
    end
  end 
end
