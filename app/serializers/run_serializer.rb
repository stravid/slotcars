class RunSerializer < ActiveModel::Serializer
  attributes :id, :time, :track_id, :user_id
end
