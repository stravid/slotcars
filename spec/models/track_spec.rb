require 'spec_helper'

describe Track do

  descibe 'validation of raphael' do
    valid_raphael = FactoryGirl.generate :valid_raphael_path
    it { should allow_value(valid_raphael).for(:raphael) }

    invalid_raphael = ['', 'M10,0z', '10,0R325,329,37,90,23,78', 'string']
    invalid_raphael.each do |value|
      it { should_not allow_value(value).for(:raphael) }
    end
  end

  it { should validate_presence_of :rasterized }

end