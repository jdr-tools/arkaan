module Arkaan
  module Rulesets
    # This module holds all the classes for the different fields types in the blueprints.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Fields
      autoload :Gauge  , 'arkaan/rulesets/fields/gauge'
      autoload :Integer, 'arkaan/rulesets/fields/integer'
    end
  end
end