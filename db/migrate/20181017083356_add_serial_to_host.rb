class AddSerialToHost < ActiveRecord::Migration[5.1]
  def change
    add_column :hosts, :serial, :string, default: ""
    add_index :hosts, :serial
  end
end
