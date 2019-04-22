class AddVisibleToMerkmalklasse < ActiveRecord::Migration[5.1]
  def change
    add_column :merkmalklassen, :visible, :string
  end
end
