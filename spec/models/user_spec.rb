require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create :user }

  subject { user }

  it { should have_many :runs }
  it { should have_many :tracks }
  it { should validate_presence_of :username}
  it { should validate_uniqueness_of :username}

  describe '#highscore' do

    it 'should get the correct highscores' do
      user_a = FactoryGirl.create :user
      user_b = FactoryGirl.create :user

      track_a = FactoryGirl.create :track
      track_b = FactoryGirl.create :track
      track_c = FactoryGirl.create :track

      track_a.runs.create :user_id => user.id, :time => 1
      track_a.runs.create :user_id => user_a.id, :time => 2
      track_a.runs.create :user_id => user_b.id, :time => 3

      track_b.runs.create :user_id => user.id, :time => 2
      track_b.runs.create :user_id => user_a.id, :time => 1
      track_b.runs.create :user_id => user_b.id, :time => 3

      track_c.runs.create :user_id => user.id, :time => 3
      track_c.runs.create :user_id => user_a.id, :time => 2
      track_c.runs.create :user_id => user_b.id, :time => 1

      highscores = user.highscores

      highscores.should include :track_id => track_a.id, :time => 1, :rank => 1
      highscores.should include :track_id => track_b.id, :time => 2, :rank => 2
      highscores.should include :track_id => track_c.id, :time => 3, :rank => 3
    end
  end
end
