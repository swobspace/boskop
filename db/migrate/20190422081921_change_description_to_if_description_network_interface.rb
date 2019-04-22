class ChangeDescriptionToIfDescriptionNetworkInterface < ActiveRecord::Migration[5.2]
  def change
    rename_column :network_interfaces, :description, :if_description
  end
end
