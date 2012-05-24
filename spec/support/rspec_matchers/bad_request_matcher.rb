RSpec::Matchers.define :be_bad_request do 
  match do |response| 
    response.code.to_s =~ /^4/ 
  end 
end