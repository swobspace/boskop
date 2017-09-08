class CreateOperatingSystems < ActiveRecord::Migration[5.1]
  def change
    create_table :operating_systems do |t|
      t.string :name
      t.text :matching_pattern

      t.timestamps
    end
  end
end
