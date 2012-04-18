require 'spec_helper'

describe Devise::RegistrationsController do

  describe '#create' do

    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env["HTTP_ACCEPT"] = "application/json"
    end

    it 'should create user and return serialized JSON for it' do

      username = "TestUser"
      email = "testuser@mail.com"
      password = "blablub"

      post :create, { :user => {
          :username => username,
          :email => email,
          :password => password
        }
      }

      created_user = User.last

      serializer = UserSerializer.new created_user, :root => "user"
      serialized_user = serializer.as_json

      response.body.should == serialized_user.to_json
      response.code.should eq '201' #created
    end

  end

end