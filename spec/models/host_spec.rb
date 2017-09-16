require 'rails_helper'

RSpec.describe Host, type: :model do
  it { is_expected.to belong_to(:host_category) }
  it { is_expected.to belong_to(:location) }
  it { is_expected.to belong_to(:operating_system) }
  it { is_expected.to have_many(:merkmale) }
  it { is_expected.to validate_presence_of(:ip) }
  it { is_expected.to validate_presence_of(:lastseen) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:host)
    g = FactoryGirl.create(:host)
    expect(f).to validate_uniqueness_of(:ip)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:host, ip: '192.0.2.77', name: 'anyhost')
    expect("#{f}").to match ("192.0.2.77 (anyhost)")
  end

  describe "Merkmale" do
    let(:host) { FactoryGirl.create(:host) }
    describe "#merkmal_doesnotexist" do
      it { expect { host.merkmal_doesnotexist }.to raise_error(NoMethodError) }
      it { expect { host.merkmal_doesnotexist=5 }.to raise_error(NoMethodError) }
    end

    describe "#merkmal_responsible" do
      let!(:merkmalklasse) { FactoryGirl.create(:merkmalklasse,
        name: "Responsible",
        tag: 'responsible',
        for_object: 'Host'
      )}
      it { expect(host.merkmal_responsible.nil?).to be_truthy }
      it { expect(host.merkmal_responsible="Mr.X").to eq("Mr.X") }
      it "assigns merkmal with value" do
        host.merkmal_responsible = "Mr.X"
        host.reload
        expect(host.merkmale.where(merkmalklasse_id: merkmalklasse.id).
               first.value).to eq("Mr.X")
      end

      context "with preassigned merkmal value" do
        let!(:merkmal) {FactoryGirl.create(:merkmal, 
          merkmalklasse_id: merkmalklasse.id,
          merkmalfor: host,
          value: "Hercule Poirot"
        )}
        it { expect(host.merkmal_responsible).to eq("Hercule Poirot") }
      end
    end
  end

end
