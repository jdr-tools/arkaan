module Arkaan
  # Utility classes for the different micro-services of the suite.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Utils
    autoload :Controller  , 'arkaan/utils/controller'
    autoload :MicroService, 'arkaan/utils/micro_service'
  end
end