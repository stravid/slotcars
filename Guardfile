
# Adds guard rules for auto-testing jasmine specs

guard 'jasmine' do
  watch(%r{app/assets/javascripts/(.+)\.(js\.coffee|js|coffee)$}) { "spec/javascripts" }
  watch(%r{spec/javascripts/(.+)\.(js\.coffee|js|coffee)$})       { "spec/javascripts" }
end
