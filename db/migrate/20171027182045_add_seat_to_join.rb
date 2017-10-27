class AddSeatToJoin < ActiveRecord::Migration
  def change
    add_column :joins,:seat,:integer
  end
end
