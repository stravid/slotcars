class Api::TracksController < Api::ApiController

  def index
    if params.has_key?(:offset) and params.has_key?(:limit)
      tracks = Track.sorted_by_date.offset(params[:offset]).limit(params[:limit])
      render :json => tracks
    else
      head :bad_request
    end
  end

  def show
    track = Track.find params[:id]
    render :json => track
  end

  def create
    return head :bad_request if params[:track].nil?
    return head :bad_request if current_user.nil?

    track = current_user.tracks.new params[:track]

    if track.save
      render :json => track, :status => :created
    else
      head :error
    end
  end

  def highscores
    track = Track.find params[:id]

    render :json => track.highscores.to_json
  end

  def random
    render :json => Track.random
  end

  def count
    render :json => Track.count.to_json
  end
end