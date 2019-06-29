shared_context "network_interface variables" do
  let!(:today) { (Date.today).to_s }
  let!(:lastmonth) { 1.month.before(Date.today).to_s }
  let!(:fourweeks) { 4.week.before(Date.today).to_s }
  let!(:twomonth) { 2.month.before(Date.today).to_s }
  let!(:loc_paris) { FactoryBot.create(:location, name: 'Paris', lid: 'PARIS') }
  let!(:loc_london) { FactoryBot.create(:location, name: 'London', lid: 'LONDON') }
  let!(:loc_berlin) { FactoryBot.create(:location, name: 'Berlin', lid: 'BER') }
  let!(:cat) { FactoryBot.create(:host_category, name: 'Server') }

  let!(:os1) { FactoryBot.create(:operating_system, name: 'ShadowOS',)}
  let!(:os2) { FactoryBot.create(:operating_system, name: 'DummyOS')}
  let!(:os3) { FactoryBot.create(:operating_system, name: 'EverytimeOS')}

  let!(:host1) { FactoryBot.create(:host,
    name: 'pc4.my.domain',
    location: loc_berlin,
    operating_system: os1,
  )}
  let!(:host2) { FactoryBot.create(:host,
    name: 'pc5.my.domain',
    location: loc_london,
    operating_system: os2,
  )}
  let!(:host3) { FactoryBot.create(:host,
    name: 'abc.other.domain',
    operating_system: os3,
    location: loc_paris,
    host_category: cat,
  )}
  let!(:if_host1) { FactoryBot.create(:network_interface,
    host: host1,
    ip: '198.51.100.17',
    mac: '00:11:22:33:44:55',
    if_description: 'brabbelfasel',
    lastseen: today,
    created_at: twomonth,
  )}
  let!(:if_host2) { FactoryBot.create(:network_interface,
    ip: '198.51.100.71',
    host: host2,
    mac: '11:22:33:44:55:66',
    lastseen: lastmonth,
  )}
  let!(:if1_host3) { FactoryBot.create(:network_interface,
    host: host3,
    ip: '192.0.2.17',
    mac: '22:33:44:55:66:77',
    lastseen: lastmonth,
  )}
  let!(:if2_host3) { FactoryBot.create(:network_interface,
    host: host3,
    ip: '192.0.2.18',
    mac: '22:33:44:55:66:77',
    lastseen: twomonth,
    created_at: twomonth,
  )}
end
