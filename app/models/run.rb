class Run < ActiveRecord::Base
  belongs_to :user
  belongs_to :track

  validates :time, :numericality => { :only_integer => true, :greater_than => 0 }
end
