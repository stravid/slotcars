require 'spec_helper'

describe Api::TracksController do

  let(:track) { FactoryGirl.create :track }
  let(:tracks) { FactoryGirl.create_list :track, 10 }

  describe '#index' do

    it 'should serialize all tracks and return them as JSON' do
      serializer = ActiveModel::ArraySerializer.new tracks, :root => "tracks"
      serialized_tracks = serializer.as_json

      get :index

      response.body.should == serialized_tracks.to_json
      response.should be_success
    end

    it 'should take offset and limit into account' do
      serializer = ActiveModel::ArraySerializer.new tracks[1..3], :root => "tracks"
      serialized_tracks = serializer.as_json

      get :index, :offset => 1, :limit => 3

      response.body.should == serialized_tracks.to_json
      response.should be_success
    end

  end

  describe '#show' do

    it 'should serialize the track with given id and return it as JSON' do
      serializer = TrackSerializer.new track, :root => "track"
      serialized_track = serializer.as_json

      get :show, :id => track.id

      response.body.should == serialized_track.to_json
    end

  end

end