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

      post :create, { :user => { :login => user.email, :password => user.password } }

      response.body.should == serialized_user.to_json
      response.should be_success
    end

    it 'should return 401 unauthorized when login failed' do
      post :create, { :user => { :login => "wrong", :password => "data" } }

      response.code.should eq '401'
    end

  end

  describe '#destroy' do

    before do
      sign_in user
    end

    it 'should return 200 if user was successfully signed out' do
      delete :destroy

      response.code.should eq '200'
    end

    it 'should return 400 when trying to sign out when nobody is signed in' do
      sign_out user

      delete :destroy

      response.code.should eq '400'
    end

  end

end