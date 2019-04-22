class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :name, default: "", null: false
      t.string :description, default: ""
      t.string :ancestry
      t.integer :ancestry_depth, null: false, default: 0
      t.integer :position, null: false, default: 0

      t.timestamps
    end
    add_index :locations, :name
    add_index :locations, :ancestry
  end
end
