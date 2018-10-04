class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :sn, default: "", null: false
      t.string :givenname, default: "", null: false
      t.string :displayname, default: ""
      t.string :title, default: ""
      t.string :anrede, default: ""
      t.string :position, default: ""
      t.string :streetaddress, default: ""
      t.string :plz, default: ""
      t.string :ort, default: ""
      t.string :postfach, default: ""
      t.string :postfachplz, default: ""
      t.string :care_of, default: ""
      t.string :telephone, default: ""
      t.string :telefax, default: ""
      t.string :mobile, default: ""
      t.string :mail, default: ""
      t.string :internet, default: ""

      t.timestamps
    end
  end
end
