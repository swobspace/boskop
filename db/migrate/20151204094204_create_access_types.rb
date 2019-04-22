class CreateAccessTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :access_types do |t|
      t.string :name, null: false
      t.text :description, default: ""

      t.timestamps null: false
    end
  end
end
