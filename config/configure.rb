# This file sets up multiple sensitive environment variables by loading and parsing 
# the 'configuration.yml' file. As the 'configuration.yml' file is not checked into version control
# it is not available in production (at least if it is deployed on Heroku)

configuration_file = "#{Rails.root}/config/configuration.yml"

if File.exists? configuration_file
  configuration_hash = YAML.load_file(configuration_file)[Rails.env].with_indifferent_access
  configuration_hash.each do |key, value|
      ENV[key.upcase] = value
  end
elsif Rails.env.development?
  throw 'Missing `config/configuration.yml` to specify important application configuration variables. You can use `config/configuration.yml.template` as base.'
end
