class CreateJoins < ActiveRecord::Migration
  def change
    create_table :joins do |t|
      t.references :user, index: true, foreign_key: true
      t.references :game, index: true, foreign_key: true
      t.integer :role
      t.boolean :vote

      t.timestamps null: false
    end
  end
end
