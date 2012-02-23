source 'https://rubygems.org'

gem 'rails', '3.2.0'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'embient'

group :development, :test do
  gem 'sqlite3'

  # adds handlebars template support to sprockets
  gem 'emberjs-rails'

  # jasmine testing + coffeescript support
  gem 'jasminerice'

  # automatically runs tests in phantomJS
  gem 'guard-jasmine'

  # for notifications of auto-test results
  gem 'growl'
end

group :production do
  gem 'pg'
end
