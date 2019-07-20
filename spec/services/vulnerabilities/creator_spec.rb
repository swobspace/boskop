require 'rails_helper'

module Vulnerabilities
  RSpec.describe Creator do
    subject { Creator.new(attributes: attributes) }
    let!(:host) { FactoryBot.create(:host, name: "Mumpitz") }
    let!(:vd1) { FactoryBot.create(:vulnerability_detail,
                 name: '4013389', threat: 'High', severity: '9.3')}

    let(:myattributes) {{
      "host_id" => host.id,
      "vulnerability_detail_id" => vd1.id,
    }}
    let(:attributes) { myattributes }

    # check for class methods
    it { expect(Creator.respond_to? :new).to be_truthy}

    # check for instance methods
    describe "instance methods" do
      it { expect(subject.respond_to? :save).to be_truthy}
      it { expect(subject.respond_to? :vulnerability).to be_truthy}
    end

    describe "without arguments" do
      it "raise an KeyError" do
        expect {
          Creator.new
        }.to raise_error(KeyError)
      end
    end

    describe "with wrong :mode" do
      it "raise an ArgumentError" do
        expect {
          Creator.new(mode: :bla, attributes: {})
        }.to raise_error(ArgumentError)
      end
    end

    describe "without existing vulnerability" do
      describe "#vulnerability" do
        it { expect(subject.vulnerability).to eq(nil) }
      end

      describe "#save" do
        describe "without :lastseen" do
          it { expect(subject.save).to be_falsey }
        end

        describe "with :lastseen" do
          let(:attributes) { myattributes.merge(lastseen: Date.today) }
          it { expect(subject.save).to be_truthy }
          it "creates a new Vulnerability" do
            expect {
              subject.save
            }.to change{Vulnerability.count}.by(1)
          end
        end

        context "creates a new new vulnerability" do
          let(:attributes) {myattributes.merge(lastseen: Date.today)}
          let(:vuln) { subject.save; subject.vulnerability }
          it { expect(subject.save).to be_truthy }

          it { expect(vuln).to be_kind_of(Vulnerability) }
          it { expect(vuln).to be_valid }
          it { expect(vuln.host).to eq(host) }
          it { expect(vuln.vulnerability_detail).to eq(vd1) }
          it { expect(vuln.lastseen.to_s).to eq("#{Date.today}") }
        end
      end
    end # non existent vulnerability

    describe "on existing vulnerability" do
      let!(:vuln) { FactoryBot.create(:vulnerability,
        host_id: host.id,
        vulnerability_detail_id: vd1.id,
        lastseen: '2019-04-01',
        plugin_output: "bla",
      )}

      describe "mode :newer and newer attributes" do
        let(:attributes) {myattributes.merge(
          lastseen: Date.today, 
          plugin_output: "quark"
        )}
        before(:each) do 
          Creator.new(mode: :newer, attributes: attributes).save
          vuln.reload
        end

        it { expect(vuln.lastseen.to_s).to eq("#{Date.today}") }
        it { expect(vuln.plugin_output).to eq("quark") }
      end

      describe "mode :newer and older attributes" do
        let(:attributes) {myattributes.merge(
          lastseen: '2018-12-04', 
          plugin_output: "quark"
        )}
        it "doesn't update vulnerability" do
          vc = Creator.new(mode: :newer, attributes: attributes)
          expect(vc.vulnerability).to eq(vuln)
          vc.save
          vulnerability = vc.vulnerability
          expect(vulnerability.lastseen.to_s).to eq("2019-04-01")
          expect(vulnerability.plugin_output).to eq("bla")
        end
      end
    end
  end
end
