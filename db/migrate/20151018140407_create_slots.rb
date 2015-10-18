class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.datetime :from
      t.datetime :to
      t.boolean :cancelled
      t.integer :formation_size
      t.string :formation_initial_size
      t.string :formation_type

      t.timestamps null: false
    end
  end
end
