class CreateFrameworkContracts < ActiveRecord::Migration[5.1]
  def change
    create_table :framework_contracts do |t|
      t.string :name, null: false
      t.text :description, default: ""
      t.date :contract_start
      t.date :contract_end
      t.integer :contract_period
      t.integer :period_of_notice
      t.string :period_of_notice_unit
      t.integer :renewal_period
      t.string :renewal_unit
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
