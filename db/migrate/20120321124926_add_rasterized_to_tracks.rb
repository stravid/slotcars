class AddRasterizedToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :rasterized, :string

  end
end
