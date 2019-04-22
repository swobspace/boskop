class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.references :addressfor, polymorphic: true, index: true
      t.string :streetaddress,	default: ""
      t.string :plz,		default: ""
      t.string :ort,		default: ""
      t.string :care_of,	default: ""
      t.string :postfach,	default: ""
      t.string :postfachplz,	default: ""

      t.timestamps
    end
  end
end
