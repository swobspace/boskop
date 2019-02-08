class AddOuiVendorToHost < ActiveRecord::Migration[5.1]
  def change
    add_column :hosts, :oui_vendor, :string
  end
end
