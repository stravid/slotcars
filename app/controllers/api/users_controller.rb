class Api::UsersController < ApplicationController
  
  def show
    user = User.find params[:id]
    render :json => user
  end
  
  def highscores
    user = User.find params[:id]
    highscores = user.highscores

    render :json => highscores.to_json
  end
  
end
