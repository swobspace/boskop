class RemoveNameFromNetwork < ActiveRecord::Migration[5.1]
  def change
    remove_column :networks, :name, :string
  end
end
