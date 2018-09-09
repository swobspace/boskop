require 'rails_helper'

RSpec.describe DownloadNessusScanService do
  let!(:nessus_scan) { FactoryBot.create(:nessus_scan,
    uuid: "9608eba4-b33d-11e8-82aa-2387b3c5dd08",
    name: "XYZ default",
    nessus_id: "1234567",
    status: "running",
    last_modification_date: 1.day.before(Date.today),
    import_state: 'new'
  )}

  let(:xmlfile) { File.join(Rails.root, 'tmp', "#{nessus_scan.uuid}.nessus") }
  let(:nessusid) { nessus_scan.nessus_id }
  subject { DownloadNessusScanService.new(nessus_id: nessusid) }

  # check for class methods
  it { expect(DownloadNessusScanService.respond_to? :new).to be_truthy}

  # check for instance methods
  describe "instance methods" do
    it { expect(subject.respond_to? :call).to be_truthy}
    it { expect(subject.call.respond_to? :success?).to be_truthy }
    it { expect(subject.call.respond_to? :error_message).to be_truthy }
    it { expect(subject.call.respond_to? :xmlfile).to be_truthy }
  end

  describe "with nonexistent nessus_id" do
    let(:nessus_id) { "nonexistent" }

    describe "#call" do
      let(:result) { subject.call }
      it { expect(result.success?).to be_falsey }
      it { expect(result.error_message.present?).to be_truthy }
      it { expect(result.xmlfile).to be_a_nil }
    end
  end

  describe "with real nessus_id" do
    let(:fake_file) {
      FileUtils.cp(
        File.join(Rails.root, 'spec', 'fixtures', 'files', 'netxp-nessus.xml'),
        xmlfile)
      true
    }

    before(:each) do
      nscan = instance_double(TenableRuby::Client)
      expect(TenableRuby::Client).to receive(:new).with(any_args).and_return(nscan)
      expect(nscan).to receive(:authenticate).and_return(true)
      expect(nscan).to receive(:report_download_file).with(any_args).and_return(fake_file)
    end

    describe "#call" do
      let(:result) { subject.call }
      it { expect(result.success?).to be_truthy }
      it { expect(result.error_message.present?).to be_falsey }
      it { expect(result.xmlfile).to be_kind_of String }
    end
  end

end
