class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|

      t.timestamps
    end
  end
end
