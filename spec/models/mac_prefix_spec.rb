require 'rails_helper'

RSpec.describe MacPrefix, type: :model do
  it { is_expected.to validate_presence_of(:oui) }

  it "should get plain factory working" do
    f = FactoryBot.create(:mac_prefix)
    g = FactoryBot.create(:mac_prefix)
    expect(f).to validate_uniqueness_of(:oui)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryBot.create(:mac_prefix, oui: '112233', vendor: "Mustermann Ltd.")
    expect("#{f}").to match ("112233 Mustermann Ltd.")
  end

end
