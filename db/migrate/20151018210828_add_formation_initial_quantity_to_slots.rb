class AddFormationInitialQuantityToSlots < ActiveRecord::Migration
  def change
    add_column :slots, :formation_initial_quantity, :integer
  end
end
