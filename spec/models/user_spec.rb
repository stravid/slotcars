require 'spec_helper'

describe User do

  let(:user) { FactoryGirl.create :user }

  subject { user }

  it { should have_many :runs }
  it { should have_many :tracks }
  it { should have_many :ghosts }
  it { should validate_presence_of :username}
  it { should validate_uniqueness_of :username}

  describe '#runs_grouped_by_track' do

    let(:track_a) { FactoryGirl.create :track }
    let(:track_b) { FactoryGirl.create :track }

    before(:each) do
      track_a.runs.create :user_id => user.id, :time => 1
      track_a.runs.create :user_id => user.id, :time => 2

      track_b.runs.create :user_id => user.id, :time => 1
      track_b.runs.create :user_id => user.id, :time => 2
    end

    it 'should return one run for each track even if multiple runs exist' do
      grouped_runs = user.runs_grouped_by_track

      grouped_runs.length.should == 2
    end

    it 'should include the track the run was grouped by' do
      grouped_runs = user.runs_grouped_by_track

      grouped_runs.first.track.should be_a Track
    end

  end

  describe '#highscore_on_track' do

    let(:track) { FactoryGirl.create :track }

    it 'should return a hash with track information' do
      track.runs.create :user_id => user.id, :time => 1

      highscore = user.highscore_on_track(track)

      highscore[:track_id].should == track.id
      highscore[:track_title].should == track.title
    end

    it 'should return a hash with run time and rank' do
      user_a = FactoryGirl.create :user

      userHighscoreTime = 2
      expectedUserRank = 2
      track.runs.create :user_id => user.id, :time => userHighscoreTime
      track.runs.create :user_id => user_a.id, :time => userHighscoreTime - 1

      highscore = user.highscore_on_track(track)

      highscore[:time].should == userHighscoreTime
      highscore[:rank].should == expectedUserRank
    end
  end

  describe '#sort_highscores_by_rank' do

    it 'should compare the rank attributes of given hash array' do
      bestHighscore = { :rank => 1 }
      secondHighscore = { :rank => 2 }

      unsortedHighscores = [secondHighscore, bestHighscore]

      sortedHighscores = user.sort_highscores_by_rank unsortedHighscores

      sortedHighscores[0].should be bestHighscore
      sortedHighscores[1].should be secondHighscore
    end

  end

  describe '#highscores_for_runs' do

    it 'should return an array of highscores for given runs' do
      firstTrack = {}
      firstRun = double("firstRun")
      firstRun.stub(:track) { firstTrack }

      secondTrack = {}
      secondRun = double("secondRun")
      secondRun.stub(:track) { secondTrack }

      runs = [firstRun, secondRun]

      firstHighscore = {}
      secondHighscore = {}

      user.should_receive(:highscore_on_track).with(firstTrack).and_return firstHighscore
      user.should_receive(:highscore_on_track).with(secondTrack).and_return secondHighscore

      highscores = user.highscores_for_runs(runs)

      highscores[0].should be firstHighscore
      highscores[1].should be secondHighscore
    end

  end

  describe '#highscores' do

    before(:each) do
      user.stub(:runs_grouped_by_track)
      user.stub(:highscores_for_runs)
      user.stub(:sort_highscores_by_rank)
    end

    it 'should get all runs grouped by track' do
      user.should_receive(:runs_grouped_by_track)
      user.highscores
    end

    it 'should get highscores for runs' do
      runs = []
      user.stub(:runs_grouped_by_track) { runs }
      user.should_receive(:highscores_for_runs).with(runs)

      user.highscores
    end

    it 'should sort the fetched highscores by rank and return it' do
      highscores = []
      sortedHighscores = []

      user.stub(:highscores_for_runs) { highscores }
      user.should_receive(:sort_highscores_by_rank).with(highscores).and_return sortedHighscores

      result = user.highscores

      result.should be sortedHighscores
    end

  end

  describe 'after create callback' do
    it 'should call StatisticsTracker.user_created' do
      StatisticsTracker.should_receive :user_created

      FactoryGirl.create :user
    end
  end
end
