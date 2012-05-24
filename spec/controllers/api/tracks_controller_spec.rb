require 'spec_helper'

describe Api::TracksController do

  let(:track) { FactoryGirl.create :track }
  let(:tracks) { FactoryGirl.create_list :track, 10 }
  let(:user) { FactoryGirl.create :user }

  describe '#index' do

    it 'should return bad request if no params for offset and limit are provided' do
      get :index

      response.should be_bad_request
    end

    it 'should take offset and limit into account' do
      offset = 1
      limit = 3
      
      tracks = Track.offset(offset).limit(limit).order("created_at DESC")
      
      serializer = ActiveModel::ArraySerializer.new tracks, :root => "tracks"
      serialized_tracks = serializer.as_json

      get :index, :offset => offset, :limit => limit

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

    let(:attributes_for_valid_track) { FactoryGirl.attributes_for(:track) }
    let(:attributes_for_invalid_track) do
      FactoryGirl.attributes_for(:track, :raphael => FactoryGirl.generate(:invalid_raphael_path))
    end

    describe 'no logged in user' do

      before(:each) do
        sign_out user
      end

      it 'should return an bad request error when no user is logged in' do
        post :create, :track => attributes_for_valid_track

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
        post :create, :track => attributes_for_valid_track

        response.code.should eq '201' # created
        Track.last.user_id.should eq user.id
      end

      it 'should serialize created track and return it as JSON' do
        post :create, :track => attributes_for_valid_track

        created_track = Track.last

        serializer = TrackSerializer.new created_track, :root => "track"
        serialized_track = serializer.as_json

        response.body.should == serialized_track.to_json
      end

      it 'should return a server error when creating track fails' do
        post :create, :track => attributes_for_invalid_track

        response.should be_error
      end
    end
  end

  describe '#random' do

    it 'should return a randomly chosen track' do
      track_ids = tracks.map { |track| track.id }

      get :random

      responseJSON = JSON.parse response.body

      track_ids.should include(responseJSON['track']['id'])
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