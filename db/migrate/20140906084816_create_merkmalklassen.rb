class CreateMerkmalklassen < ActiveRecord::Migration[5.1]
  def change
    create_table :merkmalklassen do |t|
      t.string :name, null: false, default: ""
      t.text :description, default: ""
      t.string :format, null: false, default: ""
      t.text :possible_values

      t.timestamps
    end
    add_index :merkmalklassen, :name
  end
end
