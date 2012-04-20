require 'spec_helper'

describe Api::RunsController do

  describe '#create' do

    let(:track) { FactoryGirl.create :track }
    let(:user) { FactoryGirl.create :user }

    it 'should return a bad request error code when params hash does not contain a `run` key' do
      post :create, :random_key => 'woot'

      response.should be_bad_request
    end

    it 'should return a bad request error code when there is no current user' do
      post :create, :run => { :time => 14442, :track_id => track.id }

      response.should be_bad_request
    end

    it 'should create a run with passed parameters' do
      sign_in user
      time = 14442
      post :create, :run => { :time => time, :track_id => track.id }

      response.code.should eq '201'
      Run.last.time.should eq time
      Run.last.track_id.should eq track.id
      Run.last.user_id.should eq user.id
    end

    it 'should serialize created run and return it as JSON' do
      sign_in user
      post :create, :run => { :time => 1337, :track_id => track.id }

      created_run = Run.last

      serializer = RunSerializer.new created_run, :root => 'run'
      serialized_run = serializer.as_json

      response.body.should == serialized_run.to_json
    end

    it 'should return a bad request error code if the track_id is invalid' do
      sign_in user

      post :create, :run => { :time => 1337, :track_id => Track.count + 1 }

      response.should be_bad_request
    end

    it 'should return a server error when creating a run fails' do
      sign_in user

      post :create, :run => { :time => -42, :track_id => track.id }

      response.should be_error
    end
  end

end
