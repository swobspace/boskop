require "rails_helper"
require "cancan/matchers"

RSpec.describe ApplicationHelper, :type => :helper do
  def can?(access, obj)
    true
  end

  describe "#link_to_attribute" do
    describe "with attribute :framework_contract" do
      let (:fmc) { FactoryBot.create(:framework_contract, 
				       name: "MyFrameworkContract") }

      it "raises error if method framework_contract does not exist" do
	expect {
	  link_to_attribute(Object.new, :framework_contract)
	}.to raise_error(RuntimeError)
      end

      it "returns blank string if framework_contract.nil?" do
	dbl = double
	expect(dbl).to receive(:framework_contract).and_return(nil)
	expect(link_to_attribute(dbl, :framework_contract)).to eq("--")
      end

      it "returns a link to framework_contract" do
	dbl = double "Object"
	allow(dbl).to receive(:framework_contract).at_least(:once).and_return(fmc)
	expect(link_to_attribute(dbl, :framework_contract)).to include("MyFrameworkContract")
	expect(link_to_attribute(dbl, :framework_contract)).to include(framework_contract_path(fmc))
      end

      it "returns a string" do
	dbl = double
	allow(dbl).to receive(:framework_contract).at_least(:once).and_return(fmc)
        allow(self).to receive(:can?).with(any_args).and_return(false)
	expect(link_to_attribute(dbl, :framework_contract)).to eq "MyFrameworkContract"
      end
    end

    describe "with attribute :location" do
      let (:loc) { FactoryBot.create(:location, name: "MyLocation") }

      it "raises error if method location does not exist" do
	expect {
	  link_to_attribute(Object.new, :location)
	}.to raise_error(RuntimeError)
      end

      it "returns blank string if location.nil?" do
	dbl = double
	expect(dbl).to receive(:location).and_return(nil)
	expect(link_to_attribute(dbl, :location)).to eq("--")
      end

      it "returns a link to location" do
	dbl = double
	allow(dbl).to receive(:location).at_least(:once).and_return(loc)
	expect(link_to_attribute(dbl, :location)).to include("MyLocation")
	expect(link_to_attribute(dbl, :location)).to include(location_path(loc))
      end

      it "returns a string" do
	dbl = double
	allow(dbl).to receive(:location).at_least(:once).and_return(loc)
        allow(self).to receive(:can?).with(any_args).and_return(false)
	expect(link_to_attribute(dbl, :location)).to eq "#{loc.lid} / MyLocation /  "
      end
    end
  end
  describe "#dl_notes" do
    let(:myhash) {{
      "summary" => "a short summary"
    }}
    subject { Capybara.string(helper.dl_notes(myhash)) }
    it { expect(subject.find("dl dt").text).to match("summary") }
    it { expect(subject.find("dl dd").text).to match("a short summary") }

  end
end
