class AddObjectToMerkmalklasse < ActiveRecord::Migration[5.1]
  def change
    add_column :merkmalklassen, :mandantory, :boolean, default: false
    add_column :merkmalklassen, :unique, :boolean, default: false
    add_column :merkmalklassen, :position, :integer, default: 0
    add_column :merkmalklassen, :for_object, :string, null: false, default: ''
    add_index :merkmalklassen, :for_object
  end
end
