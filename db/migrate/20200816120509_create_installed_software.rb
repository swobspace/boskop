class CreateInstalledSoftware < ActiveRecord::Migration[6.0]
  def change
    create_table :installed_software do |t|
      t.references :software_raw_datum, foreign_key: false, null: false
      t.references :host, foreign_key: false, null: false
      t.date :lastseen

      t.timestamps
    end
  end
end
