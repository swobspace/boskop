class AddTagToMerkmalklasse < ActiveRecord::Migration[5.1]
  def change
    add_column :merkmalklassen, :tag, :string, default: ""
  end
end
