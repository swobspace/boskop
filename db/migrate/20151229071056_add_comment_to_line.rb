class AddCommentToLine < ActiveRecord::Migration
  def change
    add_column :lines, :notes, :text, default: ""
  end
end
