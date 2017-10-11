require 'mongoid'
require 'active_model'
require 'active_support'

# Main module of the application, holding all the subsequent classes.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module Arkaan
  autoload :Account    , 'arkaan/account'
  autoload :Permissions, 'arkaan/permissions'
  autoload :Concerns   , 'arkaan/concerns'
  autoload :OAuth      , 'arkaan/oauth'
end