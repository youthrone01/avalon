class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.references :game, index: true, foreign_key: true
      t.integer :hoster
      t.string :players
      t.string :vote
      t.boolean :result

      t.timestamps null: false
    end
  end
end
