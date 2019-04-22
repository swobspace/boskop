class CreateLines < ActiveRecord::Migration[5.1]
  def change
    create_table :lines do |t|
      t.string :name, null: false
      t.text :description, default: ""
      t.string :provider_id, default: ""
      t.integer :location_a_id
      t.integer :location_b_id
      t.references :access_type, index: true, foreign_key: false
      t.decimal :bw_upstream, precision: 10, scale: 1
      t.decimal :bw_downstream, precision: 10, scale: 1
      t.references :framework_contract, index: true, foreign_key: false
      t.date :contract_start
      t.date :contract_end
      t.integer :contract_period
      t.integer :period_of_notice
      t.string :period_of_notice_unit
      t.integer :renewal_period
      t.string :renewal_unit
      t.references :line_state, index: true, foreign_key: false

      t.timestamps null: false
    end
    add_index :lines, :location_a_id
    add_index :lines, :location_b_id
  end
end
