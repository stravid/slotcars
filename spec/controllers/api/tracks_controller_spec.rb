require 'spec_helper'

describe Api::TracksController do

  let(:tracks) { FactoryGirl.create_list(:track, 10) }

  describe '#index' do

    it 'should respond with all tracks as JSON' do
      json_tracks = tracks.to_json

      get :index

      response.body.should == json_tracks
      response.should be_success
    end

  end
end