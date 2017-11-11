require 'mongoid'
require 'active_model'
require 'active_support'

# Main module of the application, holding all the subsequent classes.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module Arkaan
  autoload :Account       , 'arkaan/account'
  autoload :Authentication, 'arkaan/authentication'
  autoload :Concerns      , 'arkaan/concerns'
  autoload :Monitoring    , 'arkaan/monitoring'
  autoload :OAuth         , 'arkaan/oauth'
  autoload :Permissions   , 'arkaan/permissions'
end