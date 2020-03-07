class CreateSoftwareRawData < ActiveRecord::Migration[6.0]
  def change
    create_table :software_raw_data do |t|
      t.references :software, foreign_key: false
      t.string :name, default: "", null: false
      t.string :version, default: ""
      t.string :vendor, default: ""
      t.integer :count, default: 0
      t.string :operating_system, default: ""
      t.date :lastseen
      t.string :source, default: ""

      t.timestamps
    end
    add_index :software_raw_data, :name
    add_index :software_raw_data, :vendor
    add_index :software_raw_data, :operating_system
  end
end
