class ChangePatternToTypeJsonbInSoftware < ActiveRecord::Migration[6.0]
  def up
    change_column :software, :pattern, :jsonb, using: 'pattern::jsonb', default: {}
  end
  def down
    change_column :software, :pattern, :text, default: {}
  end
end
