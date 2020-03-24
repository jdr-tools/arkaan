module Arkaan
  # The monitoring module holds all the logic about the services so they can be activated or deactivated.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Monitoring
    autoload :Route  , 'arkaan/monitoring/route'
    autoload :Service, 'arkaan/monitoring/service'
  end
end