class AddVisibleToMerkmalklasse < ActiveRecord::Migration
  def change
    add_column :merkmalklassen, :visible, :string
  end
end
