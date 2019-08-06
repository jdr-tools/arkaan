module Arkaan
  # The monitoring module holds all the logic about the services so they can be activated or deactivated.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Monitoring
    autoload :Action   , 'arkaan/monitoring/action'
    autoload :Gateway  , 'arkaan/monitoring/gateway'
    autoload :Instance , 'arkaan/monitoring/instance'
    autoload :Route    , 'arkaan/monitoring/route'
    autoload :Service  , 'arkaan/monitoring/service'
    autoload :Vigilante, 'arkaan/monitoring/vigilante'
    autoload :Websocket, 'arkaan/monitoring/websocket'
  end
end