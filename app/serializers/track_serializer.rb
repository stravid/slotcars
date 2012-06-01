class TrackSerializer < ActiveModel::Serializer
  attributes :id, :raphael, :rasterized, :title, :username
  
  def username
    track.user.username
  end

end
