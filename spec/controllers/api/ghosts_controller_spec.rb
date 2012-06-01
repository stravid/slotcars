require 'spec_helper'

describe Api::GhostsController do

  let(:track) { FactoryGirl.create :track }

  describe '#create' do

    let(:user) { FactoryGirl.create :user }

    it 'should return a bad request error code when params hash does not contain a `ghost` key' do
      sign_in user
      post :create, :random_key => 'woot'

      response.should be_bad_request
    end

    it 'should return a bad request error code when there is no current user' do
      post :create, :ghost => { :time => 42, :track_id => track.id }

      response.should be_bad_request
    end

    it 'should return a bad request error code if the track_id is invalid' do
      sign_in user
      post :create, :ghost => { :time => 42, :track_id => Track.count + 1 }

      response.should be_bad_request
    end

    it 'should create a ghost with passed parameters' do
      sign_in user
      time = 42
      positions = 'tomdachecker'
      post :create, :ghost => { :time => time, :track_id => track.id, :positions => positions }

      response.code.should eq '201'
      Ghost.last.time.should eq time
      Ghost.last.positions.should eq positions
      Ghost.last.track_id.should eq track.id
      Ghost.last.user_id.should eq user.id
    end

    it 'should serialize created ghost and return it as JSON' do
      sign_in user
      post :create, :ghost => { :time => 42, :track_id => track.id, :positions => 'tomrockt' }

      created_ghost = Ghost.last

      serializer = GhostSerializer.new created_ghost, :root => 'ghost'
      serialized_ghost = serializer.as_json

      response.body.should == serialized_ghost.to_json
    end

    it 'should return a server error when creating a ghost fails' do
      sign_in user

      post :create, :ghost => { :time => -42, :track_id => track.id, :positions => 'hellotom' }

      response.should be_error
    end

    it 'should destroy the already present ghost' do
      Ghost.create! :time => 42, :user_id => user.id, :track_id => track.id, :positions => 'yeahyeah'

      sign_in user
      new_time = 40

      post :create, :ghost => { :time => new_time, :track_id => track.id, :positions => 'more yeah' }

      Ghost.first.time.should eq new_time
    end

    it 'should not except ghosts which are worse than the already present one' do
      old_time = 39
      Ghost.create! :time => old_time, :user_id => user.id, :track_id => track.id, :positions => 'yeahyeah'

      sign_in user

      post :create, :ghost => { :time => 40, :track_id => track.id, :positions => 'less yeah' }

      Ghost.first.time.should eq old_time
      response.should be_bad_request
    end

  end

  describe '#index' do

    it 'should return the next best ghost' do
      ghost_a = Ghost.create! :time => 1, :track_id => track.id, :positions => 'yeah'
      ghost_b = Ghost.create! :time => 2, :track_id => track.id, :positions => 'yeah'
      ghost_c = Ghost.create! :time => 3, :track_id => track.id, :positions => 'yeah'

      get :index, :track_id => track.id, :time => 2

      serializer = GhostSerializer.new ghost_a, :root => 'ghost'
      serialized_ghost = serializer.as_json

      response.body.should == serialized_ghost.to_json
    end

    it 'should return your ghost if it is the best' do
      ghost_a = Ghost.create! :time => 1, :track_id => track.id, :positions => 'yeah'
      ghost_b = Ghost.create! :time => 2, :track_id => track.id, :positions => 'yeah'
      ghost_c = Ghost.create! :time => 3, :track_id => track.id, :positions => 'yeah'

      get :index, :track_id => track.id, :time => 1

      serializer = GhostSerializer.new ghost_a, :root => 'ghost'
      serialized_ghost = serializer.as_json

      response.body.should == serialized_ghost.to_json
    end
  end
end
