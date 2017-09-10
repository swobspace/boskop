class ChangeIpToInet < ActiveRecord::Migration[5.1]
  def change
    change_column :hosts, :ip, :inet
  end
end
