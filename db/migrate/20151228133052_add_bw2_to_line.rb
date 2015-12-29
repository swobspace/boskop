class AddBw2ToLine < ActiveRecord::Migration
  def change
    add_column :lines, :bw2_upstream, :decimal, precision: 10, scale: 1
    add_column :lines, :bw2_downstream, :decimal, precision: 10, scale: 1
  end
end
