require 'simplecov'
SimpleCov.start do
  add_filter File.join('spec', '*')
end

require 'bundler/setup'
Bundler.setup

require 'factory_girl'
require 'database_cleaner'
require 'arkaan'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each do |filename|
  require filename
end

Dir[File.join(File.dirname(__FILE__), 'shared', '**', '*.rb')].each do |filename|
  require filename
end