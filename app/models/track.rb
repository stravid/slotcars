class Track < ActiveRecord::Base
  has_many :runs
  has_many :ghosts
  belongs_to :user  

  # regualar expression assures at least 3 points
  validates :raphael, format: { with: /\AM(R?(\d{1,4}(\.\d{1,2})?),?){6,}z\z/ }
  validates :rasterized, :presence => true
  validates :title, :presence => true

  def self.sorted_by_date(offset, limit)
    Track.offset(offset).limit(limit).order("created_at DESC")
  end

  def highscores
    runs.select('user_id, username, MIN(time) AS time').joins(:user).order(:time).group(:user_id, :username)
  end
end
