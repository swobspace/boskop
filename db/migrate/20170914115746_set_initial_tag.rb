class SetInitialTag < ActiveRecord::Migration[5.1]
  def up
    Merkmalklasse.where(tag: '').each do |mk|
      mk.update(tag: mk.name.downcase.gsub(/[^a-z_]/, '_'))
    end
  end

  def down
  end
end
