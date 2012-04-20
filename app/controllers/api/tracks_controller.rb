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

  def create
    return head :bad_request if params[:track].nil?

    track = Track.new params[:track]
    if track.save
      render :json => track, :status => :created
    else
      head :error
    end

  end

end