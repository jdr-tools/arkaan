Gem::Specification.new do |spec|
  spec.name        = 'Arkaan'
  spec.version     = '0.2.0'
  spec.date        = '2017-09-19'
  spec.summary     = 'The model layer for my table-RPG application'
  spec.description = 'This gem holds the model layer for my table-top RPG games application.'
  spec.authors     = ['Vincent Courtois']
  spec.email       = 'courtois.vincent@outlook.com'
  spec.files       = [
    'lib/arkaan.rb',
    'lib/arkaan/account.rb'
  ]
  spec.homepage    = 'https://rubygems.org/gems/arkaan'
  spec.license     = 'MIT'

  spec.add_development_dependency 'rspec'       , '3.6.0'
  spec.add_development_dependency 'factory_girl', '4.8.1'
  spec.add_development_dependency 'yard'        , '0.9.9'
  spec.add_development_dependency 'pry'         , '0.11.1'

  spec.add_runtime_dependency 'mongoid'    , '7.0.0.beta'
  spec.add_runtime_dependency 'activemodel', '5.1.4'
  spec.add_runtime_dependency 'bcrypt'     , '3.1.11'
end