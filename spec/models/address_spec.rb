require 'rails_helper'

RSpec.describe Address, :type => :model do
  it { is_expected.to belong_to(:addressfor) }

  it "should get plain factory working" do
    f = FactoryGirl.create(:address)
    g = FactoryGirl.create(:address)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryGirl.create(:address, streetaddress: "Holzweg 4", plz: "99999",
                           ort: "Nirgendwo")
    expect("#{f}").to match(/Holzweg 4/)
    expect("#{f}").to match(/99999 Nirgendwo/)
  end


end
