class AddRaphaelToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :raphael, :string

  end
end
