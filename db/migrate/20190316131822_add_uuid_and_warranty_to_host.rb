class AddUuidAndWarrantyToHost < ActiveRecord::Migration[5.2]
  def change
    add_column :hosts, :uuid, :string, default: ""
    add_index :hosts, :uuid
    add_column :hosts, :product, :string, default: ""
    add_column :hosts, :warrantay_sla, :string, default: ""
    add_column :hosts, :warranty_start, :date, default: ""
    add_column :hosts, :warranty_end, :date, default: ""
  end
end
