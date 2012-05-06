class Api::UsersController < ApplicationController
  def highscores
    user = User.find params[:id]
    highscores = user.highscores

    render :json => highscores.to_json
  end
end
