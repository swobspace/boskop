class CreateOperatingSystemMappings < ActiveRecord::Migration[5.1]
  def change
    create_table :operating_system_mappings do |t|
      t.string :field
      t.string :value
      t.references :operating_system, foreign_key: false

      t.timestamps
    end
    add_index :operating_system_mappings, :field
    add_index :operating_system_mappings, :value
  end
end
