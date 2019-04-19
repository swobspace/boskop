shared_context "host variables" do
  let!(:cat_linux) { FactoryBot.create(:host_category, name: 'linux firewall') }
  let!(:loc_paris) { FactoryBot.create(:location, name: 'Paris', lid: 'PARIS') }
  let!(:loc_london) { FactoryBot.create(:location, name: 'London', lid: 'LONDON') }
  let!(:loc_berlin) { FactoryBot.create(:location, name: 'Berlin', lid: 'BER') }

  let!(:macprefix) { FactoryBot.create(:mac_prefix, oui: '0084ED', vendor: 'Gnadenlos unlimited') }

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
    cpe: "cpe:/o:linux:linux_kernel:2.6",
    raw_os: "storage-misc",
    fqdn: 'nas01.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    location: loc_paris,
    operating_system: os1,
    vendor: 'MegaQX',
    product: 'QX1704',
    uuid: 'd4618e67-5b24-495e-94dd-fc2568c01dd6',
  )}
  let!(:pc2)  { FactoryBot.create(:host, 
    name: "MYPC002",
    description: "workstation",
    cpe: "cpe:/o:microsoft:windows_7::sp1:professional",
    raw_os: "Windows 7 Professional 7601 Service Pack 1",
    fqdn: 'mypc002.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    operating_system: os1,
    location: loc_london,
    serial: 'XXX7784N',
    uuid: 'c64af2a5-7191-4d8e-a4e0-ed6ee36d9bf6',
    vendor: 'Dell Inc.',
    product: 'OptiPlex 7010',
    warranty_start: '2017-03-01',
  )}
  let!(:pc3)  { FactoryBot.create(:host, 
    name: "MYPC003",
    description: "workstation",
    cpe: "cpe:/o:microsoft:windows_7::sp1:professional",
    raw_os: "Windows 7 Professional 7601 Service Pack 1",
    fqdn: 'mypc003.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: Date.today,
    operating_system: os2,
    location: loc_london,
    serial: 'XXX7785T',
    vendor: 'Dell Inc.',
    product: 'OptiPlex 7010',
    warranty_start: '2017-03-01',
  )}
  let!(:vpngw)  { FactoryBot.create(:host, 
    name: "vpngw",
    description: "VPN gateway",
    cpe: "cpe:/o:linux:linux_kernel:4.4",
    raw_os: "Linux 4.4",
    fqdn: 'vpngw.external.net',
    domain_dns: 'external.net',
    workgroup: '',
    lastseen: 1.month.before(Date.today),
    host_category: cat_linux,
    operating_system: os3,
    location: loc_berlin,
    vendor: 'Tuxnolinux',
  )}
  let!(:pc5)  { FactoryBot.create(:host, 
    name: "MYPC005",
    description: "very old workstation",
    cpe: "cpe:/o:microsoft:windows_xp::-",
    raw_os: "Windows 5.1",
    fqdn: 'mypc005.my.example.net',
    domain_dns: 'my.example.net',
    workgroup: 'MY',
    lastseen: 1.year.before(Date.today),
    operating_system: os2,
    location: loc_berlin,
    vendor: 'Dell Inc.',
    product: 'OptiPlex 755',
  )}

  let!(:nas_if) { FactoryBot.create(:network_interface,
    host: nas,
    ip: '198.51.100.17',
    mac: '00:84:ed:12:34:56',
  )}
  let!(:pc2_if) { FactoryBot.create(:network_interface,
    host: pc2,
    mac: '00:84:ed:00:12:02',
    ip: '198.51.100.63',
  )}
  let!(:pc3_if) { FactoryBot.create(:network_interface,
    host: pc3,
    ip: '198.51.100.66',
    mac: '00:84:ed:00:12:03',
  )}
  let!(:vpngw_if) { FactoryBot.create(:network_interface,
    host: vpngw,
    ip: '203.0.113.1',
    mac: '12:34:56:99:99:98',
  )}
  let!(:pc5_if)  { FactoryBot.create(:network_interface, 
    host: pc5,
    ip: '198.51.100.70',
    mac: '00:84:ed:00:12:05',
  )}
end

