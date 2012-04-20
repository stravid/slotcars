require 'spec_helper'

describe Run do
  it { should belong_to :user }
  it { should belong_to :track }
end
