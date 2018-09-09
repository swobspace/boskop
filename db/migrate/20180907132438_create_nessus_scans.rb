class CreateNessusScans < ActiveRecord::Migration[5.1]
  def change
    create_table :nessus_scans do |t|
      t.string :nessus_id, default: ""
      t.string :uuid,      default: ""
      t.string :name,      default: ""
      t.string :status,    default: ""
      t.date :last_modification_date
      t.string :import_state, default: ""

      t.timestamps
    end
    add_index :nessus_scans, :nessus_id
    add_index :nessus_scans, :uuid
  end
end
