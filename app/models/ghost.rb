class Ghost < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  validates :time, :numericality => { :only_integer => true, :greater_than => 0 }

  attr_accessible :time, :track_id, :positions, :user_id

  after_create :after_create_callback

  def after_create_callback
    StatisticsTracker.ghost_created
  end
end
