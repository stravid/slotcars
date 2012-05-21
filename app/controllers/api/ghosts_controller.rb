class Api::GhostsController < ApplicationController
  def create
    return head :bad_request if params[:ghost].nil? || current_user.nil?
    return head :bad_request if Track.find_by_id(params[:ghost][:track_id]).nil?

    old_ghost = current_user.ghosts.find_by_track_id params[:ghost][:track_id]

    return head :bad_request if !old_ghost.nil? and old_ghost.time > params[:ghost][:time].to_i

    old_ghost.destroy() unless old_ghost.nil?

    ghost = current_user.ghosts.new params[:ghost]

    if ghost.save
      render :json => ghost, :status => :created
    else
      head :error 
    end
  end
end