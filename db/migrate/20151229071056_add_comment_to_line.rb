class AddCommentToLine < ActiveRecord::Migration[5.1]
  def change
    add_column :lines, :notes, :text, default: ""
  end
end
