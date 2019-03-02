ENV['RACK_ENV'] = 'test'
ENV['MONGOID_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  add_filter File.join('spec', '*')
end

require 'bundler/setup'
Bundler.setup

require "rspec/json_expectations"
require 'factory_girl'
require 'rack/test'
require 'database_cleaner'
require 'arkaan'
require 'pry'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each do |filename|
  require filename
end

Dir[File.join(File.dirname(__FILE__), 'shared', '**', '*.rb')].each do |filename|
  require filename
end