class AddQuantityToSlot < ActiveRecord::Migration
  def change
    add_column :slots, :formation_quantity, :integer
  end
end
