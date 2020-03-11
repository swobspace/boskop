class CreateSoftwareGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :software_groups do |t|
      t.string :name, default: ""
      t.string :description

      t.timestamps
    end
    add_index :software_groups, :name
  end
end
