class CreateMerkmale < ActiveRecord::Migration
  def change
    create_table :merkmale do |t|
      t.references :merkmalfor, polymorphic: true, index: true
      t.references :merkmalklasse, index: true
      t.string :value

      t.timestamps
    end
  end
end
