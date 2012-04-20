class Track < ActiveRecord::Base
  has_many :runs

  # regualar expression assures at least 3 points
  validates :raphael, format: { with: /\AM(R?(\d{1,4}(\.\d{1,2})?),?){6,}z\z/ }
  validates :rasterized, :presence => true

end
