require 'spec_helper'
require 'statistics_tracker'

describe StatisticsTracker do

  describe '#tracking_enabled?' do
    it 'should always return true in production' do
      Rails.env = 'production'

      StatisticsTracker.tracking_enabled?.should be true
    end

    it 'should always return false in development' do
      Rails.env = 'development'

      StatisticsTracker.tracking_enabled?.should be false
    end

    it 'should always return false in test' do
      Rails.env = 'test'

      StatisticsTracker.tracking_enabled?.should be false
    end
  end

  describe '#track_count' do
    it 'should post to the StatHat API if tracking_enabled? returns true' do
      StatisticsTracker.stub(:tracking_enabled?).and_return true

      key = 'test key'
      value = 1

      StatHat::API.should_receive(:ez_post_count).with key, "mail@stravid.com", value
      StatisticsTracker.track_count key, value
    end

    it 'should not post to the StatHat API if tracking_enabled? returns false' do
      StatisticsTracker.stub(:tracking_enabled?).and_return false

      StatHat::API.should_not_receive(:ez_post_count)
      StatisticsTracker.track_count 'key', 1
    end
  end
end
