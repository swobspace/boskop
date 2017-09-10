class CreateHostCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :host_categories do |t|
      t.string :name, default: "", null: false
      t.text :description, default: ""

      t.timestamps
    end
  end
end
