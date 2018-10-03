require 'rails_helper'

RSpec.describe Contact, type: :model do
  it { is_expected.to have_many(:responsibilities) }
  it { is_expected.to validate_presence_of(:sn) }
  it { is_expected.to validate_presence_of(:givenname) }

  it "should get plain factory working" do
    f = FactoryBot.create(:contact)
    g = FactoryBot.create(:contact)
    expect(f).to validate_uniqueness_of(:mail).case_insensitive
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    f = FactoryBot.create(:contact, sn: 'Mustermann', givenname: "Hans", title: "Dr.")
    expect("#{f}").to match ("Mustermann, Dr. Hans")
  end

  it "to_str returns value" do
    f = FactoryBot.create(:contact, sn: 'Mustermann', givenname: "Hans", title: "Dr.",
                          mail: 'Hans.Mustermann@muster.de')
    expect("#{f.to_str}").to match ("Mustermann, Dr. Hans <Hans.Mustermann@muster.de>")
  end

  it "name returns value" do
    f = FactoryBot.create(:contact, sn: 'Mustermann', givenname: "Hans", title: "Dr.")
    expect("#{f.name}").to match ("Dr. Hans Mustermann")
  end

end
