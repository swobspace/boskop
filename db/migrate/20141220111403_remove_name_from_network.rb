class RemoveNameFromNetwork < ActiveRecord::Migration
  def change
    remove_column :networks, :name, :string
  end
end
