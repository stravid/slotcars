require 'spec_helper'

describe Run do
  it { should belong_to :user }
  it { should belong_to :track }
  it { should validate_numericality_of :time }
  it { should_not allow_value(-10).for :time }
  it { should_not allow_value(10.1).for :time }

  describe 'after create callback' do
    it 'should call StatisticsTracker.run_created' do
      StatisticsTracker.should_receive :run_created

      FactoryGirl.create :run
    end
  end
end
