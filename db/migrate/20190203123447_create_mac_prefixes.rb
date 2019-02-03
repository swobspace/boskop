class CreateMacPrefixes < ActiveRecord::Migration[5.1]
  def change
    create_table :mac_prefixes do |t|
      t.string :oui, null: false, limit: 6
      t.string :vendor, default: ""

      t.timestamps
    end
    add_index :mac_prefixes, :oui
  end
end
