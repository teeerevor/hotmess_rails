# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
ENV['current_year'] = '2016'
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
