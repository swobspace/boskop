require 'rails_helper'

module Hosts
  RSpec.describe Creator do
    subject { Creator.new(attributes: attributes) }
    let(:attributes) {{
      name: "Mumpitz",
      lastseen: "2019-04-15",
      ip: "192.0.2.35",
    }}
    # check for class methods
    it { expect(Creator.respond_to? :new).to be_truthy}

    it "raise an ArgumentError" do
    expect {
      Creator.new
    }.to raise_error(KeyError)
    end

    # check for instance methods
    describe "instance methods" do
      it { expect(subject.respond_to? :save).to be_truthy}
      it { expect(subject.respond_to? :host).to be_truthy}
    end

    describe "without existing host" do
      describe "#host" do
        it { expect(subject.host).to eq(nil) }
      end

      describe "#save" do
        it "creates a new host" do
          expect {
            subject.save
          }.to change{Host.count}.by(1)
        end

        context "saved host" do
          let(:host) { subject.save; subject.host }
          it { expect(host).to be_kind_of(Host) }
          it { expect(host).to be_valid }
          it { expect(host.name).to eq("Mumpitz") }
          it { expect(host.lastseen.to_s).to eq("2019-04-15") }
          it { expect(host.ip).to eq("192.0.2.35") }
        end
      end
    end

    describe "with existing host" do
    end

  end
end
