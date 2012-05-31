
# Adds guard rules for auto-testing jasmine specs

guard 'jasmine', :server_env => :test, :timeout => 20000 do
  watch(%r{app/assets/javascripts/(.+)\.(js\.coffee|js|coffee)$}) { "spec/javascripts" }
  watch(%r{spec/javascripts/(.+)\.(js\.coffee|js|coffee)$})       { "spec/javascripts" }
end
