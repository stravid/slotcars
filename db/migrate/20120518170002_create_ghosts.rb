class CreateGhosts < ActiveRecord::Migration
  def change
    create_table :ghosts do |t|
      t.integer :user_id
      t.integer :track_id
      t.integer :time
      t.text :positions

      t.timestamps
    end
  end
end
