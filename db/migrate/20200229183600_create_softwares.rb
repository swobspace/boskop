class CreateSoftwares < ActiveRecord::Migration[6.0]
  def change
    create_table :softwares do |t|
      t.string :name, default: "", null: false
      t.text :pattern
      t.string :vendor, default: ""
      t.text :description
      t.string :minimum_allowed_version, default: ""
      t.string :maximum_allowed_version, default: ""
      t.date :green
      t.date :yellow
      t.date :red
      t.references :software_category, foreign_key: true

      t.timestamps
    end
    add_index :softwares, :vendor
  end
end
