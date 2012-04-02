class ApplicationController < ActionController::Base
  protect_from_forgery
  serialization_scope :current_user
end
