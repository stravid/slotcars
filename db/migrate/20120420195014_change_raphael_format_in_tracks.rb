class ChangeRaphaelFormatInTracks < ActiveRecord::Migration
  def up
    change_column :tracks, :raphael, :text
  end

  def down
    change_column :tracks, :raphael, :string
  end
end
