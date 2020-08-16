require 'rails_helper'

RSpec.describe InstalledSoftware, type: :model do
  it { is_expected.to belong_to(:software_raw_datum) }
  it { is_expected.to belong_to(:host) }
  it { is_expected.to validate_presence_of(:lastseen) }

  it "should get plain factory working" do
    f = FactoryBot.create(:installed_software)
    g = FactoryBot.create(:installed_software)
    expect(f).to be_valid
    expect(g).to be_valid
  end

end
