require 'bundler/setup'
Bundler.setup

require 'factory_girl'
require 'arkaan'

Dir[File.join(File.dirname(__FILE__), 'support', '**', '*.rb')].each do |filename|
  require filename
end