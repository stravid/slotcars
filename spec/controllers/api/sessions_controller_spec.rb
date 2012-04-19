require 'spec_helper'

describe Api::SessionsController do

  let(:user) { FactoryGirl.create :user }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @request.env["HTTP_ACCEPT"] = "application/json"
  end

  describe '#create' do

    it 'should sign in user with credentials and return JSON representation' do
      serializer = UserSerializer.new user, :root => "user"
      serialized_user = serializer.as_json

      post :create, { :user => { :email => user.email, :password => user.password } }

      response.body.should == serialized_user.to_json
      response.should be_success
    end

    it 'should return 401 unauthorized when login failed' do
      post :create, { :user => { :email => "wrong", :password => "data" } }

      response.code.should eq '401'
    end

  end

end