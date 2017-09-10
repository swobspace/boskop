class AddWorkgroupDomainDnsFqdnToHost < ActiveRecord::Migration[5.1]
  def change
    add_column :hosts, :fqdn, :string, default: ""
    add_column :hosts, :workgroup, :string, default: ""
    add_column :hosts, :domain_dns, :string, default: ""
  end
end
