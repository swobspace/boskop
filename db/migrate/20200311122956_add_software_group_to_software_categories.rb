class AddSoftwareGroupToSoftwareCategories < ActiveRecord::Migration[6.0]
  def change
    add_reference :software_categories, :software_group, foreign_key: false
  end
end
