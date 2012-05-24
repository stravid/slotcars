require 'spec_helper'

describe Track do

  it { should validate_presence_of :rasterized }
  it { should validate_presence_of :title }
  it { should belong_to :user }
  it { should have_many :runs }
  it { should have_many :ghosts }
  
  describe 'validation of raphael' do
    valid_raphael_path = FactoryGirl.generate :valid_raphael_path
    it { should allow_value(valid_raphael_path).for(:raphael) }

    invalid_raphael_paths = ['', 'M10,0z', '10,0R325,329,37,90,23,78', 'string']
    invalid_raphael_paths.each do |value|
      it { should_not allow_value(value).for(:raphael) }
    end
  end

  describe 'highscores' do
    let(:track) { FactoryGirl.create :track }

    it 'should get the correct highscores' do
      user_a = FactoryGirl.create :user, :username => 'david'
      user_b = FactoryGirl.create :user, :username => 'tom'
      user_c = FactoryGirl.create :user, :username => 'dominik'

      track.runs.create :user_id => user_a.id, :time => 100
      track.runs.create :user_id => user_b.id, :time => 200
      track.runs.create :user_id => user_c.id, :time => 50
      track.runs.create :user_id => user_a.id, :time => 300

      highscores = track.highscores

      highscores[0].username.should eq 'dominik'
      highscores[0].time.should eq 50
      highscores[1].username.should eq 'david'
      highscores[1].time.should eq 100
      highscores[2].username.should eq 'tom'
      highscores[2].time.should eq 200
    end
  end
end
