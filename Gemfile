source 'https://rubygems.org'
ruby "2.0.0"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

gem 'pg'    #for the dbs
gem 'pony'  #email

gem 'haml'

gem 'sass-rails', '~> 4.0.0'
gem 'compass-rails'
gem 'fancy-buttons'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'modular-scale'
#gem 'coffee-filter'             # embed coffeescript in haml files

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
  gem 'thin' # a bit faster than webrick
  gem 'pry'
  gem 'pry-nav'
  gem 'pry-rails'
end

group :test do
  gem 'fuubar', require: false                           # rspec progress bar formatter
  gem 'rspec-rails', require: false                      # test framework
  gem 'rspec-subject_call'                               # convenient rspec extensions by yours truly
  gem 'shoulda-matchers'                                 # rails test assertions
end

#for heroku
group :production do
  gem 'unicorn'
  gem 'rails_12factor'
end
