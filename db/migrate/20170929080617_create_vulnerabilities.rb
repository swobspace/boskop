class CreateVulnerabilities < ActiveRecord::Migration[5.1]
  def change
    create_table :vulnerabilities do |t|
      t.references :host, foreign_key: false
      t.references :vulnerability_detail, foreign_key: false
      t.date :lastseen

      t.timestamps
    end
  end
end
