Gem::Specification.new do |spec|
  spec.name        = 'arkaan'
  spec.version     = '1.0.0'
  spec.date        = '2018-09-22'
  spec.summary     = 'The model layer for my table-RPG application'
  spec.description = 'This gem holds the model layer for my table-top RPG games application.'
  spec.authors     = ['Vincent Courtois']
  spec.email       = 'courtois.vincent@outlook.com'
  spec.files       = Dir['lib/**/*.rb']
  spec.homepage    = 'https://rubygems.org/gems/arkaan'
  spec.license     = 'MIT'

  spec.add_development_dependency 'rspec'                  , '3.6.0'
  spec.add_development_dependency 'rspec-json_expectations', '2.1.0'
  spec.add_development_dependency 'rack-test'              , '0.7.0'
  spec.add_development_dependency 'factory_girl'           , '4.8.1'
  spec.add_development_dependency 'database_cleaner'       , '1.6.1'
  spec.add_development_dependency 'simplecov'              , '0.15.1'
  spec.add_development_dependency 'yard'                   , '0.9.11'
  spec.add_development_dependency 'pry'                    , '0.11.1'
  spec.add_development_dependency 'draper'                 , '3.0.1'

  spec.add_runtime_dependency 'mongoid'        , '7.0.1'
  spec.add_runtime_dependency 'activemodel'    , '5.1.4'
  spec.add_runtime_dependency 'activesupport'  , '5.1.4'
  spec.add_runtime_dependency 'bcrypt'         , '3.1.11'
  spec.add_runtime_dependency 'sinatra'        , '2.0.1'
  spec.add_runtime_dependency 'sinatra-contrib', '2.0.1'
  spec.add_runtime_dependency 'platform-api'   , '2.1.0'
  spec.add_runtime_dependency 'faraday'        , '0.15.2'
end