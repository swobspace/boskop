class CreateNetworks < ActiveRecord::Migration
  def change
    create_table :networks do |t|
      t.references :location, index: true
      t.cidr :netzwerk
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
