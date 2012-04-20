class Api::RunsController < ApplicationController
  def create
    return head :bad_request if params[:run].nil? || current_user.nil?

    return head :bad_request if Track.find_by_id(params[:run][:track_id]).nil?

    run = current_user.runs.new params[:run]

    if run.save
      render :json => run, :status => :created
    else
      head :error 
    end
  end
end
