require 'rails_helper'

module SoftwareRawData
  RSpec.describe ImportCsvService do
    let(:csvfile) { File.join(Rails.root, 'spec', 'fixtures', 'files', 'raw_software.csv') }
    # check for class methods
    it { expect(ImportCsvService.respond_to? :new).to be_truthy}

    # check for instance methods
    describe "instance methods" do
      subject { ImportCsvService.new(file: "") }
      it { expect(subject.respond_to? :call).to be_truthy}
      it { expect(subject.call.respond_to? :success?).to be_truthy }
      it { expect(subject.call.respond_to? :error_message).to be_truthy }
      it { expect(subject.call.respond_to? :software_raw_data).to be_truthy }
    end

    describe "#call" do
      subject { ImportCsvService.new(file: csvfile) }

      context "with valid import_attributes" do
        it "creates an SoftwareRawDatum" do
          expect {
            subject.call
          }.to change{SoftwareRawDatum.count}.by(4)
        end

        describe "#call" do
          let(:result) { subject.call }
          it {puts result.software_raw_data.pluck(:version).inspect}
          it { expect(result.success?).to be_truthy }
          it { expect(result.error_message.present?).to be_falsey }
          it { expect(result.software_raw_data).to be_a_kind_of Array }

          describe "the first software_raw_datum" do
            let(:swr) { result.software_raw_data.first }
            it { expect(swr).to be_a_kind_of SoftwareRawDatum }
            it { expect(swr).to be_persisted }
            it { expect(swr.name.to_s).to eq("7-Zip 19.00") }
            it { expect(swr.version).to eq("19.00") }
            it { expect(swr.vendor).to eq("Igor Pavlov") }
            it { expect(swr.count).to eq(77) }
            it { expect(swr.operating_system).to eq("Windows") }
            it { expect(swr.lastseen.to_s).to match(/\A{1.day.before(Date.today).to_s}/) }
            it { expect(swr.source).to eq("docusnap") }
          end
        end
      end

      context "with invalid import_attributes" do
        subject { ImportCsvService.new(file: "") }

        it "creates an SoftwareRawDatum" do
          expect {
            subject.call
          }.to change{SoftwareRawDatum.count}.by(0)
        end

        describe "#call" do
          let(:result) { subject.call }
          it { expect(result.success?).to be_falsey }
          it { expect(result.error_message.present?).to be_truthy }
          it { expect(result.software_raw_data.first).to be_nil }
        end
      end
    end

    describe "with existing software_raw_datum" do
      let(:result) { ImportCsvService.new(file: csvfile).call }
      let!(:swr) { FactoryBot.create(:software_raw_datum,
        "name" => "7-Zip 19.00",
        "version" => "19.00",
        "vendor" => "Igor Pavlov",
        "count" => "5",
        "operating_system" => "Windows",
        "lastseen" => "2020-02-29",
        "source" => "docusnap",
      )}
      let(:swr_new) { result.software_raw_data.first }
      it { expect(result.success?).to be_truthy }
      it { expect(result.error_message.present?).to be_falsey }
      it { expect(swr_new).to be_kind_of SoftwareRawDatum }
      it { expect(swr_new.lastseen.to_s).to eq(1.day.before(Date.today).to_s) }
      it { expect(swr_new.count).to eq(77) }
    end

  end
end
