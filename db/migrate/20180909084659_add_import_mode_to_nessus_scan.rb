class AddImportModeToNessusScan < ActiveRecord::Migration[5.1]
  def change
    add_column :nessus_scans, :import_mode, :string, default: ""
  end
end
