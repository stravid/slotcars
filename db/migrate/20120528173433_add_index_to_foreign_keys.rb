class AddIndexToForeignKeys < ActiveRecord::Migration
  def change
    add_index :ghosts, :user_id
    add_index :ghosts, :track_id
    add_index :runs, :user_id
    add_index :runs, :track_id
    add_index :tracks, :user_id
  end
end
