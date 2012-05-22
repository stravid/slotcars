require 'spec_helper'

describe Ghost do
  it { should belong_to :user }
  it { should belong_to :track }
  it { should validate_numericality_of :time }
  it { should_not allow_value(-10).for :time }
  it { should_not allow_value(10.1).for :time }
end
