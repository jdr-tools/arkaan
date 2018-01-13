Gem::Specification.new do |spec|
  spec.name        = 'arkaan'
  spec.version     = '0.7.9'
  spec.date        = '2018-01-12'
  spec.summary     = 'The model layer for my table-RPG application'
  spec.description = 'This gem holds the model layer for my table-top RPG games application.'
  spec.authors     = ['Vincent Courtois']
  spec.email       = 'courtois.vincent@outlook.com'
  spec.files       = Dir['lib/**/*.rb']
  spec.homepage    = 'https://rubygems.org/gems/arkaan'
  spec.license     = 'MIT'

  spec.add_development_dependency 'rspec'           , '3.6.0'
  spec.add_development_dependency 'rack-test'       , '0.7.0'
  spec.add_development_dependency 'factory_girl'    , '4.8.1'
  spec.add_development_dependency 'database_cleaner', '1.6.1'
  spec.add_development_dependency 'simplecov'       , '0.15.1'
  spec.add_development_dependency 'yard'            , '0.9.9'
  spec.add_development_dependency 'pry'             , '0.11.1'

  spec.add_runtime_dependency 'mongoid'      , '7.0.0.beta'
  spec.add_runtime_dependency 'activemodel'  , '5.1.4'
  spec.add_runtime_dependency 'activesupport', '5.1.4'
  spec.add_runtime_dependency 'bcrypt'       , '3.1.11'
  spec.add_runtime_dependency 'sinatra'      , '2.0.0'
end