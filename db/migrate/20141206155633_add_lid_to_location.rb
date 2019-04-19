class AddLidToLocation < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :lid, :string
    add_index :locations, :lid
  end
end
