class ChangeContractPeriod < ActiveRecord::Migration
  def up
    change_column :lines, :contract_period, :string, default: ""
    change_column :framework_contracts, :contract_period, :string, default: ""
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
