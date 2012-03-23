class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable

  # Setup accessible (or protected) attributes for your model
  # other are :password_confirmation, :remember_me
  attr_accessible :username, :email, :password

  protected

  def self.find_for_database_authentication(conditions={})
    self.where("username = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end
end
