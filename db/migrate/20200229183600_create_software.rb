class CreateSoftware < ActiveRecord::Migration[6.0]
  def change
    create_table :software do |t|
      t.string :name, default: "", null: false
      t.text :pattern
      t.string :vendor, default: ""
      t.text :description
      t.string :minimum_allowed_version, default: ""
      t.string :maximum_allowed_version, default: ""
      t.date :green
      t.date :yellow
      t.date :red
      t.references :software_category, foreign_key: false

      t.timestamps
    end
    add_index :software, :vendor
  end
end
