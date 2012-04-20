class ChangeLimitOfRaphael < ActiveRecord::Migration
  def up
    change_column :tracks, :raphael, :text, :limit => 64000
  end

  def down
    change_column :tracks, :raphael, :text
  end
end
