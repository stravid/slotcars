class Api::TracksController < Api::ApiController

  def index
    if params.has_key?(:offset) && params.has_key?(:limit)
      tracks = Track.offset(params[:offset]).limit(params[:limit])
    else
      tracks = Track.all
    end

    render :json => tracks
  end

  def show
    track = Track.find params[:id]
    render :json => track
  end
end