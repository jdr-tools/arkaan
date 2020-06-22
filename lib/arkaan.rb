require 'mongoid'
require 'active_model'
require 'active_support'
require 'dotenv/load'

# Main module of the application, holding all the subsequent classes.
# @author Vincent Courtois <courtois.vincent@outlook.com>
module Arkaan
  autoload :Account       , 'arkaan/account'
  autoload :Authentication, 'arkaan/authentication'
  autoload :Campaign      , 'arkaan/campaign'
  autoload :Campaigns     , 'arkaan/campaigns'
  autoload :Chatroom      , 'arkaan/chatroom'
  autoload :Chatrooms     , 'arkaan/chatrooms'
  autoload :Concerns      , 'arkaan/concerns'
  autoload :Event         , 'arkaan/event'
  autoload :Factories     , 'arkaan/factories'
  autoload :Files         , 'arkaan/files'
  autoload :Monitoring    , 'arkaan/monitoring'
  autoload :Notification  , 'arkaan/notification'
  autoload :OAuth         , 'arkaan/oauth'
  autoload :Permissions   , 'arkaan/permissions'
  autoload :Phone         , 'arkaan/phone'
  autoload :Ruleset       , 'arkaan/ruleset'
end