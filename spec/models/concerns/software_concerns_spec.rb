require 'rails_helper'

RSpec.describe SoftwareConcerns, type: :model do
  let(:sw1) { FactoryBot.create(:software, 
    red: 1.year.after(Date.today),
    yellow: 1.month.after(Date.today),
    green: 1.year.before(Date.today)
  )}
  let(:sw2) { FactoryBot.create(:software, 
    red: 1.year.after(Date.today),
    yellow: 1.month.before(Date.today),
  )}
  let(:sw3) { FactoryBot.create(:software, 
    red: 1.year.before(Date.today),
  )}
  let(:sw4) { FactoryBot.create(:software)}
  let(:sw5) { FactoryBot.create(:software,
    green: 1.year.before(Date.today)
  )}

  it { expect(sw1.status(:color)).to eq("green") }
  it { expect(sw1.status(:show_date)).to eq(1.year.before(Date.today)) }
  it { expect(sw2.status(:color)).to eq("yellow") }
  it { expect(sw2.status(:show_date)).to eq(1.month.before(Date.today)) }
  it { expect(sw3.status(:color)).to eq("red") }
  it { expect(sw3.status(:show_date)).to eq(1.year.before(Date.today)) }
  it { expect(sw4.status(:color)).to eq("grey") }
  it { expect(sw4.status(:show_date)).to be_nil }
  it { expect(sw5.status(:color)).to eq("green") }
  it { expect(sw5.status(:show_date)).to eq(1.year.before(Date.today)) }


end
