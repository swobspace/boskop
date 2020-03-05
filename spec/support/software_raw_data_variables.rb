shared_context "software_raw_data variables" do
  let(:sw1) { FactoryBot.create(:software,
    name: "Microsoft Visual Studio Runtime",
    vendor: "Microsoft Corporation",
    pattern: {'name' => '.*studio.*(runtime|laufzeit)', "vendor" => 'microsoft'}
  )}
  let(:sw2) { FactoryBot.create(:software,
    name: "Wrong Software",
    vendor: "Wrong Vendor"
  )}
  let!(:raw1) { FactoryBot.create(:software_raw_datum,
    name: "Microsoft Visual Studio 2010 Runtime",
    version: "10.0.50903",
    vendor: "Microsoft Corporation",
    count: "22",
    operating_system: "Windows",
    lastseen: '2020-03-01',
    source: "docusnap",
    software_id: sw1.id
  )}
  let!(:raw2) { FactoryBot.create(:software_raw_datum,
    name: "Microsoft Visual Studio 2010 Laufzeit",
    version: "10.0.50903",
    vendor: "Microsoft Corporation",
    count: "3",
    operating_system: "Windows",
    lastseen: '2020-03-02',
    source: "docusnap",
    software_id: sw2.id
  )}
  let!(:raw3) { FactoryBot.create(:software_raw_datum,
    name: "7-Zip 19.00 (x64 edition)",
    version: "19.00.00.0",
    vendor: "Igor Pavlov",
    count: "44",
    operating_system: "Windows",
    lastseen: '2020-03-05',
    source: "docusnap"
  )}
  let!(:raw4) { FactoryBot.create(:software_raw_datum,
    name: "7-Zip 19.00",
    version: "19.00",
    vendor: "Igor Pavlov",
    count: "5",
    operating_system: "Windows",
    lastseen: '2020-02-29',
    source: "other"
  )}
  let!(:raw5) { FactoryBot.create(:software_raw_datum,
    name: "TightVNC 1.3.10",
    version: "1.3.10",
    vendor: "TightVNC Group",
    count: "1",
    operating_system: "Windows",
    lastseen: '2019-10-12',
    created_at: '2016-02-02',
    source: "other"
  )}
end

