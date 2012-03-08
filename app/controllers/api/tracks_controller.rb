class Api::TracksController < Api::ApiController

  def index
    tracks = Track.all
    render :json => tracks
  end
end