class AddLidToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :lid, :string
    add_index :locations, :lid
  end
end
