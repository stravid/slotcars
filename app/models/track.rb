class Track < ActiveRecord::Base

  # regualar expression assures at least 3 points
  validates :raphael, format: { with: /\AM(R?(\d{1,4}\.\d{2}),?){6,}z\z/ }
  validates :rasterized, :presence => true

end
