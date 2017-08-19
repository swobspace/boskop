class CreateHostCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :host_categories do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
