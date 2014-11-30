class AddBaselinkToMerkmalklasse < ActiveRecord::Migration
  def change
    add_column :merkmalklassen, :baselink, :string, default: ""
  end
end
