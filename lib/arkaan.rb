require 'mongoid'
require 'active_model'
require 'active_support'
require 'sinatra/base'
require 'sinatra/config_file'
require 'platform-api'

# Main module of the application, holding all the subsequent classes.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module Arkaan
  autoload :Account       , 'arkaan/account'
  autoload :Authentication, 'arkaan/authentication'
  autoload :Campaign      , 'arkaan/campaign'
  autoload :Campaigns     , 'arkaan/campaigns'
  autoload :Concerns      , 'arkaan/concerns'
  autoload :Dacorators    , 'arkaan/decorators'
  autoload :Phone         , 'arkaan/factories'
  autoload :Monitoring    , 'arkaan/monitoring'
  autoload :OAuth         , 'arkaan/oauth'
  autoload :Permissions   , 'arkaan/permissions'
  autoload :Phone         , 'arkaan/phone'
  autoload :Utils         , 'arkaan/utils'
end