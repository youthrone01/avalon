class ChangeResultTypeInTasks < ActiveRecord::Migration
  def change
  	change_column :tasks, :result, :string
  end
end
