require 'rails_helper'

RSpec.describe SoftwareCategory, type: :model do
  it { is_expected.to have_many(:software) }
  it { is_expected.to validate_presence_of(:name) }

  it "should get plain factory working" do
    f = FactoryBot.create(:software_category)
    g = FactoryBot.create(:software_category)
    expect(f).to be_valid
    expect(g).to be_valid

    is_expected.to validate_uniqueness_of :name
  end

  it "to_s returns value" do
    f = FactoryBot.create(:software_category, name: "SomeCategory")
    expect("#{f}").to be == "SomeCategory"
  end

end
