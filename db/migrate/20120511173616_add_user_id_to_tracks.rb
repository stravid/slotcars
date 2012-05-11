class AddUserIdToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :user_id, :integer

  end
end
