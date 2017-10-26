class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :game, index: true, foreign_key: true
      t.boolean :result

      t.timestamps null: false
    end
  end
end
