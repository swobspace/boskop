class AddBaselinkToMerkmalklasse < ActiveRecord::Migration[5.1]
  def change
    add_column :merkmalklassen, :baselink, :string, default: ""
  end
end
