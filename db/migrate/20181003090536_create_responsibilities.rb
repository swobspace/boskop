class CreateResponsibilities < ActiveRecord::Migration[5.1]
  def change
    create_table :responsibilities do |t|
      t.references :responsibility_for, polymorphic: true, index: { name: 'index_responsibility_for' }
      t.references :contact
      t.string :role, default: ""
      t.string :title, default: ""
      t.integer :position, default: 0

      t.timestamps
    end
    add_index :responsibilities, :role
  end
end
