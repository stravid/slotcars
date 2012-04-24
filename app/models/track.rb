class Track < ActiveRecord::Base
  has_many :runs

  # regualar expression assures at least 3 points
  validates :raphael, format: { with: /\AM(R?(\d{1,4}(\.\d{1,2})?),?){6,}z\z/ }
  validates :rasterized, :presence => true

  def highscores
    Run.find_by_sql(["
      SELECT
        username,
        user_id,
        MIN(time) AS time
      FROM runs
      INNER JOIN users
      ON (runs.user_id = users.id)
      WHERE track_id='?'
      GROUP BY user_id, username
      ORDER BY time ASC
    ", self.id])
  end
end
