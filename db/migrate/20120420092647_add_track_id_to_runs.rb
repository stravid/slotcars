class AddTrackIdToRuns < ActiveRecord::Migration
  def change
    add_column :runs, :track_id, :integer

  end
end
