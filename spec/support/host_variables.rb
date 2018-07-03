shared_context "host variables" do
  let!(:cat_linux) { FactoryBot.create(:host_category, name: 'linux firewall') }
  let!(:loc_paris) { FactoryBot.create(:location, name: 'Paris', lid: 'PARIS') }
  let!(:loc_london) { FactoryBot.create(:location, name: 'London', lid: 'LONDON') }
  let!(:loc_berlin) { FactoryBot.create(:location, name: 'Berlin', lid: 'BER') }

  let(:os1) { FactoryBot.create(:operating_system, 
    name: 'DummyOS',
    eol: 5.years.before(Date.today)
  )}
  let(:os2) { FactoryBot.create(:operating_system, 
    name: 'ShadowOS', 
    eol: 3.years.after(Date.today)
  )}
  let(:os3) { FactoryBot.create(:operating_system, 
    name: 'EverytimeOS'
  )}
  # order "name asc": MYNAS01, MYPC002, MYPC003, MYPC005, vpngw
  let!(:nas)  { FactoryBot.create(:host, 
    name: "MYNAS01",
    description: "Backup station",
    ip: '198.51.100.17',
    cpe: "cpe:/o:linux:linux_kernel:2.6",
    raw_os: "storage-misc",
    fqdn: 'nas01.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    mac: '00:84:ed:12:34:56',
    location: loc_paris,
    operating_system: os1,
  )}
  let!(:pc2)  { FactoryBot.create(:host, 
    name: "MYPC002",
    description: "workstation",
    ip: '198.51.100.63',
    cpe: "cpe:/o:microsoft:windows_7::sp1:professional",
    raw_os: "Windows 7 Professional 7601 Service Pack 1",
    fqdn: 'mypc002.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    mac: '00:84:ed:00:12:02',
    operating_system: os1,
    location: loc_london,
  )}
  let!(:pc3)  { FactoryBot.create(:host, 
    name: "MYPC003",
    description: "workstation",
    ip: '198.51.100.66',
    cpe: "cpe:/o:microsoft:windows_7::sp1:professional",
    raw_os: "Windows 7 Professional 7601 Service Pack 1",
    fqdn: 'mypc003.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    mac: '00:84:ed:00:12:03',
    operating_system: os2,
    location: loc_london,
  )}
  let!(:vpngw)  { FactoryBot.create(:host, 
    name: "vpngw",
    description: "VPN gateway",
    ip: '203.0.113.1',
    cpe: "cpe:/o:linux:linux_kernel:4.4",
    raw_os: "Linux 4.4",
    fqdn: 'vpngw.external.net',
    domain_dns: 'external.net',
    workgroup: '',
    lastseen: 1.month.before(Date.today),
    mac: '12:34:56:99:99:98',
    host_category: cat_linux,
    operating_system: os3,
    location: loc_berlin,
  )}
  let!(:pc5)  { FactoryBot.create(:host, 
    name: "MYPC005",
    description: "very old workstation",
    ip: '198.51.100.70',
    cpe: "cpe:/o:microsoft:windows_xp::-",
    raw_os: "Windows 5.1",
    fqdn: 'mypc005.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: 1.year.before(Date.today),
    mac: '00:84:ed:00:12:05',
    operating_system: os2,
    location: loc_berlin,
  )}
end

