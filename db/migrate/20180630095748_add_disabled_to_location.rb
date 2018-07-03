class AddDisabledToLocation < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :disabled, :boolean, default: false
    add_index :locations, :disabled
  end
end
