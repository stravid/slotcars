class ChangeRasterizedFormatInTracks < ActiveRecord::Migration
  def up
    change_column :tracks, :rasterized, :text, :limit => 64000
  end

  def down
    change_column :tracks, :rasterized, :string
  end
end
