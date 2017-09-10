class CreateHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :hosts do |t|
      t.string :name, default: "", null: false
      t.text :description, default: ""
      t.cidr :ip
      t.string :cpe, default: ""
      t.string :lanmanager, default: ""
      t.references :operating_system, foreign_key: false
      t.date :lastseen
      t.string :mac, default: ""
      t.references :host_category, foreign_key: false
      t.references :location, foreign_key: false

      t.timestamps
    end
    add_index :hosts, :cpe
    add_index :hosts, :lanmanager
  end
end
