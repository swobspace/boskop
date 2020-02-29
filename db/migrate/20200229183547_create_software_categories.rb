class CreateSoftwareCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :software_categories do |t|
      t.string :name, default: "", null: false
      t.text :description
      t.text :main_business_process

      t.timestamps
    end
  end
end
