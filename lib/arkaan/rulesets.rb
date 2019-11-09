module Arkaan
  # The rulesets module holds all the logic for components present inside a ruleset.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  module Rulesets
    autoload :Blueprint, 'arkaan/rulesets/blueprint'
    autoload :Field    , 'arkaan/rulesets/field'
    autoload :Fields   , 'arkaan/rulesets/fields'
    autoload :Gauge    , 'arkaan/rulesets/gauge'
    autoload :Integer  , 'arkaan/rulesets/integer'
    autoload :Sheet    , 'arkaan/rulesets/sheet'
    autoload :Sheets   , 'arkaan/rulesets/sheets'
  end
end