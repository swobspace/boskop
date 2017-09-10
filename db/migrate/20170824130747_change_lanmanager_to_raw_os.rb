class ChangeLanmanagerToRawOs < ActiveRecord::Migration[5.1]
  def change
    rename_column :hosts, :lanmanager, :raw_os
  end
end
