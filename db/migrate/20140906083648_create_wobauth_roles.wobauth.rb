# This migration comes from wobauth (originally 20140501113226)
class CreateWobauthRoles < ActiveRecord::Migration
  def change
    create_table :wobauth_roles do |t|
      t.string :name

      t.timestamps
    end
  end
end
