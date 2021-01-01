require "rails_helper"
require "cancan/matchers"

RSpec.describe SoftwareHelper, :type => :helper do
  before(:each) do
    allow(controller).to receive(:can?).and_return(true)
  end

  describe "#matching_raw_software_link" do
    context "with valid software" do
      subject { Capybara.string(helper.matching_raw_software_link(sw)) }
      let(:sw) { FactoryBot.create(:software) }
      it { expect(subject.find("a")['href']).to match(search_software_raw_data_path({software_id: sw.id, use_pattern: true})) }
      it { expect(subject.find("a")['class']).to match("btn btn-secondary") }
     end 
    context "without software" do
      let(:sw) { nil }
      subject { helper.matching_raw_software_link(sw) }
      it { expect(subject).to eq("") }
    end
  end

  describe "#assing_raw_software_link" do
    context "with valid software" do
      subject { Capybara.string(helper.assign_raw_software_link(sw)) }
      let(:sw) { FactoryBot.create(:software) }
      it { expect(subject.find("a")['href']).to match(assign_raw_software_software_path(sw)) }
      it { expect(subject.find("a")['class']).to match("btn btn-secondary") }
     end 
    context "without software" do
      let(:sw) { nil }
      subject { helper.assign_raw_software_link(sw) }
      it { expect(subject).to eq("") }
    end
  end

  describe "#software_category_link" do
    context "with valid software" do
      subject { Capybara.string(helper.software_category_link(swcat)) }
      let(:swcat) { FactoryBot.create(:software_category) }
      it { expect(subject.find("a")['href']).to match(software_category_path(swcat)) }
     end 
    context "without software" do
      let(:swcat) { nil }
      subject { helper.software_category_link(swcat) }
      it { expect(subject).to eq("") }
    end
  end

end
