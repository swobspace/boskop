class AddVulnRiskToHost < ActiveRecord::Migration[5.1]
  def change
    add_column :hosts, :vuln_risk, :string, default: ""
    add_index :hosts, :vuln_risk
  end
end
