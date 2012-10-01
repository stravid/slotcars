class Run < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  validates :time, :numericality => { :only_integer => true, :greater_than => 0 }

  attr_accessible :time, :track_id, :user_id

  after_create :after_create_callback

  def after_create_callback
    StatisticsTracker.run_created
  end
end
