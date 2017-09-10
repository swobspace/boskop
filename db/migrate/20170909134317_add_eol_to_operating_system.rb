class AddEolToOperatingSystem < ActiveRecord::Migration[5.1]
  def change
    add_column :operating_systems, :eol, :date
  end
end
