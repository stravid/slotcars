require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create :user }

  subject { user }

  it { should have_many :runs }
  it { should validate_presence_of :username}
  it { should validate_uniqueness_of :username}
end
