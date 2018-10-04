require 'rails_helper'

RSpec.describe Responsibility, type: :model do
  it { is_expected.to belong_to(:contact).inverse_of(:responsibilities) }
  it { is_expected.to belong_to(:responsibility_for) }
  it { is_expected.to validate_presence_of(:responsibility_for_type).on(:update) }
  it { is_expected.to validate_presence_of(:responsibility_for_id).on(:update) }
  it { is_expected.to validate_presence_of(:contact_id) }
  it { is_expected.to validate_inclusion_of(:role).in_array(Boskop.responsibility_role) }


  it "should get plain factory working" do
    f = FactoryBot.create(:responsibility)
    g = FactoryBot.create(:responsibility)
    expect(f).to be_valid
    expect(g).to be_valid
  end

  it "to_s returns value" do
    contact = FactoryBot.build_stubbed(:contact, sn: 'Mustermann', givenname: "Hans")
    loc     = FactoryBot.build_stubbed(:location, lid: 'ABC')
    resp    = FactoryBot.create(:responsibility, contact: contact, 
                                responsibility_for: loc, 
                                role: "Vulnerabilities", title: "Patchmanager")
    expect("#{resp}").to match ("Mustermann, Hans (Patchmanager)")
  end

  it "get some order" do
    loc = FactoryBot.create(:location)
    f = FactoryBot.create(:responsibility, position: 0, responsibility_for: loc)
    g = FactoryBot.create(:responsibility, position: 0, responsibility_for: loc)
    expect(f.position).to eq 1
    expect(g.position).to eq 2
  end

  it "scopes position on responsibility_for" do
    ou1 = FactoryBot.create(:location)
    ou2 = FactoryBot.create(:location)
    resp11 = FactoryBot.create(:responsibility, responsibility_for: ou1)
    resp12 = FactoryBot.create(:responsibility, responsibility_for: ou1)
    resp13 = FactoryBot.create(:responsibility, responsibility_for: ou1)
    resp2  = FactoryBot.create(:responsibility, responsibility_for: ou2)

    expect(resp11.position).to eq(1)
    expect(resp12.position).to eq(2)
    expect(resp13.position).to eq(3)
    expect(resp2.position).to eq(1)
  end

end
