class CreateHosts < ActiveRecord::Migration[5.1]
  def change
    create_table :hosts do |t|
      t.string :name
      t.text :description
      t.cidr :ip
      t.string :cpe
      t.string :lanmanager
      t.references :operating_system, foreign_key: true
      t.date :lastseen
      t.string :mac
      t.references :host_category, foreign_key: true
      t.references :location, foreign_key: true

      t.timestamps
    end
    add_index :hosts, :cpe
    add_index :hosts, :lanmanager
  end
end
