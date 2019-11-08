module Arkaan
  # Static factories are used to create decorated objects easily.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Factories
    autoload :Gateways, 'arkaan/factories/gateways'
    autoload :Errors  , 'arkaan/factories/errors'
  end
end