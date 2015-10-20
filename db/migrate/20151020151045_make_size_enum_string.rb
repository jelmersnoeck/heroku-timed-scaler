class MakeSizeEnumString < ActiveRecord::Migration
  def up
    change_column :slots, :formation_size, :string
  end

  def down
    change_column :slots, :formation_size, :integer
  end
end
