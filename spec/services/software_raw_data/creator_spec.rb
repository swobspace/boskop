require 'rails_helper'

module SoftwareRawData
  RSpec.describe Creator do
    subject { Creator.new(attributes: attributes) }
    let(:attributes) {{
      "name" => "7-Zip 19.00",
      "version" => "19.00",
      "vendor" => "Igor Pavlov",
      "count" => "5",
      "operating_system" => "NixOS",
      "lastseen" => "2020-02-29",
      "source" => "docusnap",
    }}

    # check for class methods
    it { expect(Creator.respond_to? :new).to be_truthy}

    # check for instance methods
    describe "instance methods" do
      it { expect(subject.respond_to? :save).to be_truthy}
      it { expect(subject.respond_to? :software_raw_datum).to be_truthy}
    end

    describe "without arguments" do
      it "raise an KeyError" do
        expect {
          Creator.new
        }.to raise_error(KeyError)
      end
    end

    describe "with missing mandantory argument" do
      [:name, :vendor, :version].each do |arg|
        it "raise an ArgumentError" do
          attribs = attributes.except(arg.to_s)
          expect {
            Creator.new(attributes: attribs)
          }.to raise_error(ArgumentError)
        end
      end
    end

    describe "without existing raw data" do
      describe "#software_raw_datum" do
        it { expect(subject.software_raw_datum).to eq(nil) }
      end

      describe "#save" do
        describe "without :lastseen" do
          before(:each) do
            attributes['lastseen'] = nil
          end
          it { expect(subject.save).to be_truthy }
        end

        context "creates a new entry" do
          let(:swr) { subject.save; subject.software_raw_datum }
          it { expect(subject.save).to be_truthy }
          it { expect(swr).to be_kind_of(SoftwareRawDatum) }
          it { expect(swr).to be_valid }
          it { expect(swr.name).to eq("7-Zip 19.00") }
          it { expect(swr.vendor).to eq("Igor Pavlov") }
          it { expect(swr.count).to eq(5) }
          it { expect(swr.operating_system).to eq("NixOS") }
          it { expect(swr.lastseen.to_s).to eq("2020-02-29") }
          it { expect(swr.source).to eq("docusnap") }
        end
      end
    end

    describe "on existing software_raw_datum" do
      let(:swr) { subject.save && subject.software_raw_datum }
      let!(:existing_swr) { FactoryBot.create(:software_raw_datum,
        "name" => "7-Zip 19.00",
        "version" => "19.00",
        "vendor" => "Igor Pavlov",
        "count" => "17",
        "operating_system" => "NixOS",
        "lastseen" => "2020-03-01",
        "source" => "scanner"
      )}

      it { expect(SoftwareRawDatum.count).to eq(1) }

      it "doesn't create a new entry" do
        expect {
          subject.save
        }.to change{SoftwareRawDatum.count}.by(0)
      end

      describe "no update with older data" do
        it { expect(SoftwareRawDatum.count).to eq(1) }
        it { expect(swr.count).to eq(17) }
        it { expect(swr.lastseen.to_s).to eq("2020-03-01") }
        it { expect(swr.source).to eq("scanner") }
      end

      describe "update with newer data" do
        before(:each) do
          attributes['lastseen'] = Date.today.to_s
        end
        it { expect(SoftwareRawDatum.count).to eq(1) }
        it { expect(swr.count).to eq(5) }
        it { expect(swr.lastseen.to_s).to eq(Date.today.to_s) }
        it { expect(swr.source).to eq("docusnap") }
      end

      describe "new entry with different operating system" do
        before(:each) do
          attributes['lastseen'] = Date.today.to_s
          attributes['operating_system'] = "FullOS"
        end
        it { expect(subject.save && SoftwareRawDatum.count).to eq(2) }
        it { expect(swr.name).to eq("7-Zip 19.00") }
        it { expect(swr.vendor).to eq("Igor Pavlov") }
        it { expect(swr.count).to eq(5) }
        it { expect(swr.operating_system).to eq("FullOS") }
        it { expect(swr.lastseen.to_s).to eq(Date.today.to_s) }
        it { expect(swr.source).to eq("docusnap") }
      end
    end
  end
end
