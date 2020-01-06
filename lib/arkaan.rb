require 'mongoid'
require 'active_model'
require 'active_support'
require 'sinatra/base'
require 'sinatra/config_file'
require 'platform-api'
require 'draper'
require 'faraday'
require 'sinatra/custom_logger'
require 'dotenv/load'

# Main module of the application, holding all the subsequent classes.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module Arkaan
  autoload :Account       , 'arkaan/account'
  autoload :Authentication, 'arkaan/authentication'
  autoload :Campaign      , 'arkaan/campaign'
  autoload :Campaigns     , 'arkaan/campaigns'
  autoload :Concerns      , 'arkaan/concerns'
  autoload :Factories     , 'arkaan/factories'
  autoload :Files         , 'arkaan/files'
  autoload :Monitoring    , 'arkaan/monitoring'
  autoload :Notification  , 'arkaan/notification'
  autoload :OAuth         , 'arkaan/oauth'
  autoload :Permissions   , 'arkaan/permissions'
  autoload :Phone         , 'arkaan/phone'
  autoload :Ruleset       , 'arkaan/ruleset'
end