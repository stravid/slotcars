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

  def runs_grouped_by_track
    runs.select("track_id").group("track_id").order('').includes(:track)
  end

  def highscore_on_track(track)
    track.highscores.each_with_index do |highscore, index|
      if highscore.user_id == self.id
        return {
          :track_id => track.id,
          :track_title => track.title,
          :time => highscore.time,
          :rank => index + 1
        }
      end
    end
  end

  def sort_highscores_by_rank(highscores)
    highscores.sort! { |highscoreA, highscoreB| highscoreA[:rank] <=> highscoreB[:rank] }
  end

  def highscores_for_runs(runs)
    highscores = []

    runs.each do |run|
      highscores << highscore_on_track(run.track)
    end

    highscores
  end

  def highscores
    user_runs = runs_grouped_by_track
    user_highscores = highscores_for_runs user_runs
    sort_highscores_by_rank user_highscores
  end
end
