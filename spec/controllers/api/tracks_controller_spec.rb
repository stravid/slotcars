require 'spec_helper'

describe Api::TracksController do

  let(:tracks) { FactoryGirl.create_list(:track, 10) }

  describe '#index' do

    it 'should serialize all tracks and return them as JSON' do
      serializer = ActiveModel::ArraySerializer.new tracks, :root => "tracks"
      serialized_tracks = serializer.as_json

      get :index

      response.body.should == serialized_tracks.to_json
      response.should be_success
    end

  end
end