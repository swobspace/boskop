class CreateOrgUnits < ActiveRecord::Migration
  def change
    create_table :org_units do |t|
      t.string :name, default: "", null: false
      t.string :description, default: ""
      t.string :ancestry
      t.integer :ancestry_depth, null: false, default: 0
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :org_units, :name
    add_index :org_units, :ancestry
  end
end
