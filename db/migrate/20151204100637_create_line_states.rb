class CreateLineStates < ActiveRecord::Migration
  def change
    create_table :line_states do |t|
      t.string :name, null: false
      t.text :description, default: ""
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
