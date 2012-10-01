module StatisticsTracker
  def self.tracking_enabled?
    Rails.env.production?
  end

  def self.track_count key, value
    StatHat::API.ez_post_count(key, "mail@stravid.com", value) if self.tracking_enabled?
  end

  def self.track_created
    self.track_count 'tracks created', 1
  end

  def self.run_created
    self.track_count 'runs created', 1
  end

  def self.ghost_created
    self.track_count 'ghosts created', 1
  end

  def self.user_created
    self.track_count 'users created', 1
  end
end
