module Arkaan
  # Utility classes for the different micro-services of the suite.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Utils
    autoload :Controllers , 'arkaan/utils/controllers'
    autoload :Errors      , 'arkaan/utils/errors'
    autoload :Loaders     , 'arkaan/utils/loaders'
    autoload :MicroService, 'arkaan/utils/micro_service'
  end
end