class User < ActiveRecord::Base
  has_many :runs

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable, :rememberable, :trackable
  devise :database_authenticatable, :registerable, :validatable

  # Setup accessible (or protected) attributes for your model
  # other are :password_confirmation, :remember_me
  attr_accessible :username, :email, :password

  validates :username, :presence => true, :uniqueness => true

  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end

  def highscores
    user_runs = runs.group(:id, :track_id).includes(:track)
    track_highscores = {}

    user_runs.each do |run|
      track_highscores[run.track.id] = run.track.highscores
    end

    user_highscores = []

    track_highscores.each_pair do |track_id, highscore|
      highscore.each_with_index do |run, index|
        if run.user_id == self.id
          user_highscores << {
            :track_id => track_id,
            :time => run.time,
            :rank => index + 1
          }
        end
      end
    end

    user_highscores
  end
end
