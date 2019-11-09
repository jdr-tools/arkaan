module Arkaan
  module Rulesets
    # This module regroups the entities embedded in a character sheet template.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    module Sheets
      autoload :Attribute, 'arkaan/rulesets/sheets/attribute'
      autoload :Category , 'arkaan/rulesets/sheets/category'
    end
  end
end