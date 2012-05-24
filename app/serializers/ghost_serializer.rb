class GhostSerializer < ActiveModel::Serializer
  attributes :id, :time, :track_id, :user_id, :positions
end
