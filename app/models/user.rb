class User < ActiveRecord::Base
  has_many :runs
  has_many :tracks
  has_many :ghosts

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
    user_runs = runs.select("id, track_id").group(:id, :track_id).includes(:track)

    user_highscores = []

    user_runs.each do |run|
      run.track.highscores.each_with_index do |highscore, index|
        if highscore.user_id == self.id
          user_highscores << {
            :track_id => run.track.id,
            :track_title => run.track.title,
            :time => highscore.time,
            :rank => index + 1
          }
        end
      end
    end

    user_highscores
  end
end
