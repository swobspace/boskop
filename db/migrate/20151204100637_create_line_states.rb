class CreateLineStates < ActiveRecord::Migration
  def change
    create_table :line_states do |t|
      t.string :name
      t.text :description
      t.boolean :active

      t.timestamps null: false
    end
  end
end
