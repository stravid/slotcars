require 'spec_helper'

describe Track do

  describe 'validation of raphael' do
    valid_raphael_path = FactoryGirl.generate :valid_raphael_path
    it { should allow_value(valid_raphael_path).for(:raphael) }

    invalid_raphael_paths = ['', 'M10,0z', '10,0R325,329,37,90,23,78', 'string']
    invalid_raphael_paths.each do |value|
      it { should_not allow_value(value).for(:raphael) }
    end
  end

  it { should validate_presence_of :rasterized }

end