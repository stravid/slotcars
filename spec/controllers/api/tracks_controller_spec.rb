require 'spec_helper'

describe Api::TracksController do

  let(:track) { FactoryGirl.create :track }
  let(:tracks) { FactoryGirl.create_list :track, 10 }
  let(:user) { FactoryGirl.create :user }

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

  describe '#create' do

    describe 'no logged in user' do

      before(:each) do
        sign_out user
      end

      it 'should return an bad request error when no user is logged in' do
        post :create, :track => { :raphael => FactoryGirl.generate(:valid_raphael_path), :rasterized => 'rasterized path points' }

        response.should be_bad_request
      end
    end

    describe 'logged in user' do

      before(:each) do
        sign_in user
      end

      it 'should return an bad request error when params hash does not contain a `track` key' do
        post :create, :some_key => 'bla'

        response.should be_bad_request
      end

      it 'should create a track using the passed params for the current user' do
        post :create, :track => { :raphael => FactoryGirl.generate(:valid_raphael_path), :rasterized => 'rasterized path points' }

        response.code.should eq '201' # created
        Track.last.user_id.should eq user.id
      end

      it 'should serialize created track and return it as JSON' do
        post :create, :track => { :raphael => FactoryGirl.generate(:valid_raphael_path), :rasterized => 'rasterized path points' }

        created_track = Track.last

        serializer = TrackSerializer.new created_track, :root => "track"
        serialized_track = serializer.as_json

        response.body.should == serialized_track.to_json
      end

      it 'should return a server error when creating track fails' do
        post :create, :track => { :raphael => FactoryGirl.generate(:invalid_raphael_path), :rasterized => 'rasterized path points' }

        response.should be_error
      end
    end
  end

  describe '#count' do

    it 'should return the number of tracks as JSON' do
      count = tracks.count

      get :count

      response.body.should eq count.to_json
    end
  end

end