class CreateNetworkInterfaces < ActiveRecord::Migration[5.2]
  def up
    create_table :network_interfaces do |t|
      t.references :host, foreign_key: false
      t.string :description, default: ""
      t.inet :ip
      t.date :lastseen
      t.macaddr :mac
      t.string :oui_vendor, default: ""
      t.timestamps
    end

    Host.find_each do |host|
      NetworkInterface.create!(
        host_id: host.id,
        ip: host.ip,
        mac: (host.mac if host.mac =~ /[A-F0-9]{12}/),
        lastseen: host.lastseen,
        oui_vendor: host.oui_vendor
      )
    end
    remove_columns :hosts, :ip, :mac, :oui_vendor
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
