class User < ActiveRecord::Base
  has_many :runs

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable, :rememberable, :trackable
  devise :database_authenticatable, :registerable, :validatable

  # Setup accessible (or protected) attributes for your model
  # other are :password_confirmation, :remember_me
  attr_accessible :username, :email, :password

  validates_presence_of :username
  validates_uniqueness_of :username

  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.strip.downcase }]).first
  end

end
