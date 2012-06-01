class Track < ActiveRecord::Base
  has_many :runs
  has_many :ghosts
  belongs_to :user

  # regualar expression assures at least 3 points
  validates :raphael, format: { with: /\AM(R?(\d{1,4}(\.\d{1,2})?),?){6,}z\z/ }
  validates :rasterized, :presence => true
  validates :title, :presence => true

  attr_accessible :raphael, :rasterized, :title, :user_id

  def self.sorted_by_date
    Track.order("created_at DESC")
  end

  def highscores
    highscores = runs.select('user_id, username, MIN(time) AS time, RANK() OVER(ORDER BY MIN(time))').joins(:user).group(:user_id, :username)

    # cast rank to integer - this is not possible in the query (sadly)
    highscores.each { |run| run.rank = run.rank.to_i }
  end

  def self.random
    self.order('RANDOM()').first
  end

end
