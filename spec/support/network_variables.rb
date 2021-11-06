shared_context "network variables" do
  let!(:paris) { FactoryBot.create(:location, name: 'Paris', lid: 'PARIS') }
  let!(:london) { FactoryBot.create(:location, name: 'London', lid: 'LONDON') }
  let!(:berlin) { FactoryBot.create(:location, name: 'Berlin', lid: 'BER') }

  let!(:net1)  { FactoryBot.create(:network, 
    netzwerk: "198.51.100.0/24",
    description: "Internes Netzwerk",
    location: berlin,
  )}

  let!(:net2)  { FactoryBot.create(:network, 
    netzwerk: "192.0.2.0/24",
    description: "DMZ Netzwerk",
    location: london,
  )}

  let!(:net3)  { FactoryBot.create(:network, 
    netzwerk: "203.0.113.0/24",
    description: "Netzwerk Paris",
    location: paris,
  )}
end

