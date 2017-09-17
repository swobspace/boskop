class AddTagToHostCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :host_categories, :tag, :string, default: ""
  end
end
