class Track < ActiveRecord::Base
  has_many :runs
  belongs_to :user
  
  # regualar expression assures at least 3 points
  validates :raphael, format: { with: /\AM(R?(\d{1,4}(\.\d{1,2})?),?){6,}z\z/ }
  validates :rasterized, :presence => true

  def highscores
    runs.select('user_id, username, MIN(time) AS time').joins(:user).order(:time).group(:user_id, :username)
  end
end
