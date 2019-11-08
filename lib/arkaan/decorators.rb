module Arkaan
  # Decorators are used to enrich the features of the model classes without making it too big.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Decorators
    autoload :Gateway, 'arkaan/decorators/gateway'
    autoload :Errors , 'arkaan/decorators/errors'
  end
end