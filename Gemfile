source 'https://rubygems.org'
ruby "2.3.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.6'
gem 'actionpack-action_caching'

gem 'pg'    #for the dbs
gem 'pony'  #email

gem 'haml'

gem 'react-rails', '~> 1.5.0'
gem 'susy'
gem 'sass-rails', '~> 4.0.3'
gem 'compass-rails'
gem 'animation'
gem 'coffee-rails', '~> 4.0.0'
gem 'modular-scale'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'

gem 'gon'         # injectind data js/dom
gem 'rabl'        # json templating
gem 'oj'          # json parsing

#needed so rake works on heroku
gem 'nokogiri'
gem 'googleajax'

group :development do
  gem 'puma' # a bit faster than webrick
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'rubocop', require: false
  gem 'guard-livereload', require: false
  gem 'rack-livereload'
  gem 'html2haml', '~> 2.0.0.beta.1'
end

group :development, :test do
  gem 'fuubar', require: false                           # rspec progress bar formatter
  gem 'rspec-rails', require: false                      # test framework
  gem 'teaspoon-mocha'
  gem 'phantomjs'
  gem 'magic_lamp'
end

#for heroku
group :production do
  gem 'unicorn'
  gem 'rails_12factor'
  gem 'uglifier'
end
